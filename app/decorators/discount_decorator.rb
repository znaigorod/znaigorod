# encoding: utf-8

class DiscountDecorator < ApplicationDecorator
  decorates :discount

  def when_with_price
    h.content_tag :p, h.content_tag(:span, human_when, :class => :when)
  end

  def human_when
    return "Действует: #{I18n.l(starts_at, :format => '%e.%m')} - #{I18n.l(ends_at, :format => '%e.%m.%Y')}".squish
  end

  def place
    PlaceDecorator.new(:organization => organization) if geo_present?
  end

  def html_description
    @html_description ||= description.to_s.as_html
  end

  def geo_present?
    organization_id? && !organization.latitude.blank? && !organization.longitude.blank?
  end

  def similar_discount
    count = geo_present? ? 3 : 5
    HasSearcher.searcher(:similar_discount).more_like_this(discount).limit(count).results.map { |d| DiscountDecorator.new d }
  end
end
