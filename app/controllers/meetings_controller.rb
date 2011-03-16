class MeetingsController < ApplicationController
  before_filter :authenticate_user!
  inherit_resources

  def index
    index! do |format|
      format.json
      format.html
    end
    current_user.update_attribute(:unviewed_meetings_count, 0)
  end

  def create
    create! do |format|
      format.js
    end
  end

  def update
    update! do |format|
      format.js
    end
  end

  def show
    @meeting = Meeting.for_user(current_user).find(params[:id])
  end

  def destroy
    destroy! do |format|
      format.js
    end
  end

  private

  def collection
    @meetings =  if params[:datetime_from] && params[:datetime_to]
      from, to = Time.at(params[:datetime_from].to_i).to_date, Time.at(params[:datetime_to].to_i).to_date
      Meeting.in_date_range(from, to).for_user(current_user).select([:id, :datetime_from, :datetime_to, :notice, :user_id]).all
    else
      []
    end
  end

  def begin_of_association_chain
    current_user
  end
end
