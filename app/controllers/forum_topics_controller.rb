class ForumTopicsController < ApplicationController
  before_filter :authenticate_user!
  inherit_resources
  belongs_to :forum

  def create
    create!(:location => forum_forum_topics_path(parent))
  end

  private

  def collection
    @forum_topics ||= end_of_association_chain.paginate(:page => params[:page], :per_page => ForumTopic.per_page)
  end
end
