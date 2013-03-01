class EntertainmentsController < ApplicationController
  def index
    @entertainments_presenter = EntertainmentsPresenter.new(params)

    render partial: 'organizations/organizations_list', layout: false and return if request.xhr?
  end
end
