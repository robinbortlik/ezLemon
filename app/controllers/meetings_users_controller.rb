class MeetingsUsersController < ApplicationController
  before_filter :authenticate_user!
  inherit_resources
  belongs_to :meeting

  def create
    parent.users << current_user
  end

  def destroy
    MeetingsUser.destroy_all(:user_id => current_user, :meeting_id => parent)
  end

end
