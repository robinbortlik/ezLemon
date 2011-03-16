class ForumsController < ApplicationController
  before_filter :authenticate_user!
  inherit_resources
  before_filter :check_admin_access, :except => [:index, :show]

  def check_admin_access
    raise 'AccessDenied' unless admin?
  end
  
  private

  def collection
    required_forum_languages = Language.where(:code => ["EN", current_user.application_language_code])
    @forums ||= Forum
      .where(current_user.is_admin? ? {} : {:language_id => current_user.teaching_languages + current_user.learning_languages + required_forum_languages})
      .order(:title)
      .paginate(:page => params[:page], :per_page => Forum.per_page)
  end
end
