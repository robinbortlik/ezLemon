class ExcercisesController < ApplicationController
  before_filter :authenticate_user!
  inherit_resources

  def create
    @excercise = Excercise.create(params[:excercise])
    if @excercise.persisted?
      redirect_to @excercise.is_private? ? edit_excercises_result_path(@excercise.excercises_results.first) : @excercise
    else
      render :new
    end
  end

  def update_preview
    @excercise = Excercise.new(params[:excercise])
    @excercise.generate
  end

  def select_type
  end

  private

  def collection
    @excercises ||= Excercise.where(["excercises_results.teacher_id = :user_id OR excercises_results.pupil_id = :user_id", {:user_id => current_user}])
    .order('excercises.created_at DESC')
    .includes(:excercises_results)
    .paginate(:page => params[:page], :per_page => Excercise.per_page)
  end

  def begin_of_association_chain
    current_user
  end
end
