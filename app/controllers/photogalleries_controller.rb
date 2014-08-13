class PhotogalleriesController < ApplicationController

  def index
    @photogalleries = Photogallery.order('id desc')
    @p = PhotogalleryDecorator.decorate(@photogalleries)
  end

  def show
    @photogallery = Photogallery.find(params[:id])
    @works = @photogallery.works.ordered.page(params[:page]).per(12)

    render :partial => 'works/photogallery_list' and return if request.xhr?
  end
end