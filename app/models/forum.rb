class Forum < ActiveRecord::Base
  stampable
  validates :title, :presence => true, :length => {:maximum => 100}
  validates :language_id, :presence => true
  
  has_many :forum_topics, :order => "last_post_at DESC, created_at DESC"
  belongs_to :last_poster, :class_name => "User", :foreign_key => "last_post_by"
  belongs_to :user
  belongs_to :language

  # TODO : add counter cache
  def posts_count
    forum_topics.inject(0) {|x,y| x+y.posts.count}
  end

  def to_s
    language.to_s
  end

  def self.per_page
    9
  end
end
