class ForumTopic < ActiveRecord::Base
  stampable
  
  validates :title, :presence => true, :length => {:maximum => 100, :minimum => 3}

  belongs_to :forum
  belongs_to :last_poster, :class_name => "User", :foreign_key => "last_post_by"
  has_many :forum_posts

  after_save :update_last_post_attributes
  
  def self.per_page
    10
  end

  def to_s
    title
  end

  protected
  def update_last_post_attributes
    forum.update_attributes :last_post_at => last_post_at,
                            :last_post_by => last_post_by
  end

  
end
