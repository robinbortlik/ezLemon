class TeachersController < ApplicationController
  before_filter :authenticate_user!
  inherit_resources
  defaults :resource_class => PupilsTeacher, :collection_name => 'pupils_teachers', :instance_name => 'pupils_teacher'
  actions :all, :except => [ :edit, :update]

  def create
    pupils_teacher = current_user.pupils_teachers.create(params[:pupils_teacher])
    @user = pupils_teacher.teacher
  end

  def languages
    @user = User.find(params[:teacher_id])
  end

  def destroy
    @user = resource.teacher
    resource.destroy
  end
  
  protected

  def collection
    @teachers = User.where(:teaching_language_users => {:language_id => current_user.learning_languages}).except_user(current_user).includes(:teaching_language_users).paginate(:page => params[:page])
  end

  def begin_of_association_chain
    current_user
  end
end
