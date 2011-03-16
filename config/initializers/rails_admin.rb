require "rails_admin/application_controller"

module RailsAdmin
  class ApplicationController < ::ApplicationController
    before_filter :check_admin_access

    def check_admin_access
      raise ActionController::RoutingError.new('Only for admin') unless current_user && current_user.is_admin?
    end
  end
end


RailsAdmin.config do |config|

  config.excluded_models += [Comment, ExcercisesResult, LearningLanguageUser, MeetingsUser, PupilsTeacher, TeachingLanguageUser]

end
