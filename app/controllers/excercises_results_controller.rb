class ExcercisesResultsController < ApplicationController
  before_filter :authenticate_user!
  inherit_resources

  def update
    update!(:location => edit_resource_path )
  end
  
  private

  def collection
    @excercises_results ||= end_of_association_chain.paginate(:page => params[:page], :per_page => ExcerciseResult.per_page)
  end
end
