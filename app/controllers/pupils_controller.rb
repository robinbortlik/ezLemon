class PupilsController < ApplicationController
  before_filter :authenticate_user!
  inherit_resources
  defaults :resource_class => PupilsTeacher, :collection_name => 'teachers_pupils', :instance_name => 'teachers_pupil'
  actions :all, :except => [ :edit, :update]

  def create
    teachers_pupil = current_user.teachers_pupils.create(params[:teachers_pupil])
    @user = teachers_pupil.pupil
  end

  def languages
    @user = User.find(params[:pupil_id])
  end

  def destroy
    @user = resource.pupil
    resource.destroy
  end

  protected
  def collection
    @pupils = User.where(:learning_language_users => {:language_id => current_user.teaching_languages}).except_user(current_user).includes(:learning_language_users).paginate(:page => params[:page])
  end

  def begin_of_association_chain
    current_user
  end
end
