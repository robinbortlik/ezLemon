class ForumPostsController < ApplicationController
  before_filter :authenticate_user!
  inherit_resources
  belongs_to :forum do
    belongs_to :forum_topic
  end
   
  actions :all, :only => [:index, :new, :create]

  def create
    create!(:location => forum_forum_topic_forum_posts_path(Forum.find(parent.forum_id), parent))
  end

  def update
    update!(:location => forum_forum_topic_forum_posts_path(Forum.find(parent.forum_id), parent))
  end
  
  private

  def collection
    @forum_posts ||= end_of_association_chain.paginate(:page => params[:page], :per_page => ForumPost.per_page)
  end
end
