# encoding: utf-8

class OrganizationsController < ApplicationController
  has_scope :page, :default => 1

  helper_method :scrolltrack, :top_introduction?, :category_content

  before_filter :allow_cross_domain_access

  def index
    respond_to do |format|
      format.html {
        @presenter = OrganizationsPresenterBuilder.new(params).build
        @categories = @presenter.category ? @presenter.category.root.children.order(:position) : OrganizationCategory.roots.order(:position)
        @reviews = ReviewDecorator.decorate(OrganizationCategory.find(@presenter.category.slug).reviews) if @presenter.category
        @afishas = AfishaPresenter.new(per_page: @presenter.category.afisha_per_page, :without_advertisement => true, :order_by => 'creation', :categories => @presenter.category.afisha_kind.to_a) if @presenter.category.try(:afisha_kind).present?

        add_breadcrumb "Все организации", organizations_path

        if @presenter.category
          add_breadcrumb @presenter.category.root.title, organizations_by_category_path(@presenter.category.root)
          add_breadcrumb @presenter.category.title, organizations_by_category_path(@presenter.category) if !@presenter.category.is_root?
        end

        if request.xhr?
          if @presenter.view_type == 'list'
            render partial: 'not_client_list_view', layout: false
          else
            if @presenter.special_case?
              render partial: "#{@presenter.view_prefix}tile_view_posters", layout: false and return if params[:not_clients_page].blank?
            else
              render partial: 'tile_view_posters', layout: false and return if params[:not_clients_page].blank?
            end

            render partial: 'organizations/not_client_posters', layout: false
          end
        end
      }

      format.json {
        searcher = HasSearcher.searcher(:manage_organization, params).paginate(:page => params[:page], :per_page => 10)

        render :json => searcher.results
      }

      format.promotion {
        presenter = OrganizationsPresenterBuilder.new(params.merge(:per_page => 5)).build

        @collection = presenter.clients

        render :partial => 'promotions/organizations', :locals => { :presenter => presenter }
      }
    end
  end

  def add
    @presenter = OrganizationsCatalogPresenter.new(params)
  end

  def send_mail
    @presenter = OrganizationsCatalogPresenter.new(params)
  end

  def show
    if request.subdomain.blank? || !Organization.exists?(:subdomain => request.subdomain)
      @organization = Organization.find(params[:id])
    else
      @organization = Organization.find_by_subdomain(request.subdomain)
    end

    if @organization.primary_organization
      @slave_organization = @organization
      @organization = @organization.primary_organization
    end

    @organization = OrganizationDecorator.decorate @organization

    respond_to do |format|
      format.html  do
        @organization.delay(:queue => 'critical').create_page_visit(request.session_options[:id], request.user_agent, current_user)
        @visits = @organization.visits.page(1)

        @presenter = NewOrganizationsPresenter.new({:latitude => @organization.latitude.to_f, :longitude => @organization.longitude.to_f,
                                                    :radius => 50, :slug => @organization.most_valueable_organization_category.slug})

        cookie = cookies['_znaigorod_afisha_list_settings'].to_s
        settings_from_cookie = {}
        settings_from_cookie = Rack::Utils.parse_nested_query(cookie) if cookie.present?
        organization_ids = [@organization.id, @organization.situated_organization_ids].flatten
        @afisha_presenter = AfishaPresenter.new(organization_ids: organization_ids, order_by: 'starts_at', page: params[:page], :per_pageage => 9)
        @discount_presenter = DiscountsPresenter.new(organization_id: organization_ids, :type => 'discount', order_by: settings_from_cookie.merge(params)['order_by'], page: params[:page])
        @certificate_presenter = DiscountsPresenter.new(organization_id: organization_ids, :type => 'certificate', :order_by => 'random', :page => params[:page])
        @coupon_presenter = DiscountsPresenter.new(organization_id: organization_ids, :type => 'coupon', :order_by => 'random', :page => params[:page])
        @reviews = ReviewDecorator.decorate(@organization.reviews.published.order('id desc'))

        render partial: @afisha_presenter.partial,
          locals: { afishas: @afisha_presenter.decorated_collection, :presenter => @afisha_presenter },
          layout: false and return if request.xhr?
        render layout: "organization_layouts/#{@organization.subdomain}" if @organization.client? && @organization.subdomain? && template_exists?(@organization.subdomain, 'layouts/organization_layouts')
      end

      format.promotion do
        render :partial => 'promotions/organization', :locals => { :decorated_organization => @organization }
      end
    end
  end

  def photogallery
    @organization = OrganizationDecorator.find(params[:id])
  end

  def affiche
    @organization = OrganizationDecorator.find(params[:id])
    @presenter = AfficheCollection.new(params.merge(list_settings: cookies['_znaigorod_afisha_list_settings']).merge(organization: @organization))
    render partial: @presenter.view_partial, layout: false and return if request.xhr?
  end

  def tour
    @organization = OrganizationDecorator.find(params[:id])
  end

  def in_bounding_box
    searcher = HasSearcher.searcher(:organizations, params).
      with_logotype.
      order_by_rating.
      paginate(page: 1, per_page: 100)

    data = OrganizationDecorator.decorate(searcher.results).map do |organization|
      {
        id: organization.id,
        latitude: organization.address.latitude,
        longitude: organization.address.longitude,
        category: Russian.translit(organization.category.split(',')[0].to_s.squish.gsub(' ', '_').gsub('-', '_')).downcase,
        title: organization.title,
      }
    end

    render :json => data
  end

  def details_for_balloon
    organization = OrganizationDecorator.decorate(Organization.find(params[:id]))
    data = {
      address: organization.address.to_s,
      logo: organization.logotype_url,
      phones: organization.decorated_suborganizations.first.decorated_phones,
      schedule_today: organization.decorated_suborganizations.first.schedule_today,
      title: organization.title.text_gilensize,
      url: organization.show_url,
    }

    render :json => data
  end

  def allow_cross_domain_access
    response.headers['Access-Control-Allow-Origin'] = '*'
  end

  def show_phone
    if request.xhr?
      organization = Organization.find(params[:organization_id])
      organization.phone_lookups.delay.create!
      phone = params[:single_phone] ? "Тел.: #{organization.phone.split(',').try(:first)}" : "Телефон: #{organization.phone}"
      render text: phone.html_safe and return
    end

    render :nothing => true, :status => 404 and return
  end

  def increment_site_link_counter
    if request.xhr?
      Organization.find(params[:organization_id]).increment!(:site_link_counter)
      render :nothing => true, :status => 200
    end

    render :nothing => true, :status => 404
  end

  def scrolltrack(key)
    @organization.navigation_collection[key].present? ? 'js-scrolltrack' : ''
  end

  def top_introduction?
    %w(kafe_tomska restorany saunas).include? @presenter.category.try(:slug)
  end

  def category_content
    File.exists?(Rails.root.join("app/views/organizations/content/_#{@presenter.category.try(:slug)}.html.erb")) ? "#{@presenter.category.slug}" : 'default'
  end
end
