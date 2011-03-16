class ForumPost < ActiveRecord::Base
  stampable
  record_activities :dependent => :destroy
  
  validates :body, :presence => true

  belongs_to :forum_topic

  after_save :update_last_post_attributes

  def self.per_page
    10
  end

  protected
  def update_last_post_attributes
    forum_topic.update_attributes :last_post_at => created_at,
                            :last_post_by => creator_id
  end

end
