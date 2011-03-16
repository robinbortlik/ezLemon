class VideosController < ApplicationController
  before_filter :authenticate_user!
  inherit_resources
  actions :all, :only => [:index, :new, :create, :show]

  private

  def collection
    @search = end_of_association_chain.search(params[:search])
    @videos ||= @search.paginate(:page => params[:page], :per_page => resource_class.per_page)
  end
end
