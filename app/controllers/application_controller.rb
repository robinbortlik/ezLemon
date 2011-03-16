require "application_responder"

class ApplicationController < ActionController::Base
  include Userstamp
  self.responder = ApplicationResponder
  respond_to :html, :js
  before_filter :set_locale, :set_timezone

  protect_from_forgery
  layout 'application'

  def admin?
    current_user && current_user.is_admin?
  end

  helper_method :admin?

  def set_stampers
    User.stamper = current_user
  end

  def index
    if user_signed_in?
      @activities = Activity.where(
        "(activities.actor_id IN (?) AND subject_type IN (?)) 
        OR (activities.actor_id = ? AND subject_type IN (?))
        OR target_id = ?",
        current_user.assigned_user_ids, ["Comment","Document", "Video", "Meeting", "MeetingsUser", "ExcercisesUser", "ForumPost"],
        current_user, ["Excercise"],
        current_user)
      .includes(:actor => [:teachers, :pupils]).paginate(:page => params[:page], :per_page => 10)
    else
      @activities = Activity.order('created_at DESC').limit(3)
    end
  end

  def about_project
  end

  def wall_of_fame
    @users = User.where(:email => [])
  end

  def latest_activity
    @activities = Activity.order('created_at DESC').limit(30).paginate(:page => params[:page], :per_page => 10)
  end

  def ajax_timezone
    session[:timezone_offset] = (params[:offset].to_i * -60) if params[:offset]
    render :nothing => true
  end

   def set_locale
    I18n.locale = user_signed_in? ? current_user.application_language_code.downcase.to_sym : params[:locale]
  end

  private

    def set_timezone
    Time.zone = if user_signed_in?
      ActiveSupport::TimeZone[current_user.time_zone]
    elsif session[:timezone_offset]
      ActiveSupport::TimeZone[session[:timezone_offset]]
    end
  end

  def default_url_options(options={})
    user_signed_in? ? {} : { :locale => I18n.locale }
  end
end
