class Video < ActiveRecord::Base
  stampable
  belongs_to :language
  acts_as_commentable
  record_activities :dependent => :destroy

  validates :url, :presence => true, :format => { :with => URI::regexp(["http", "https"]) }, :on => :create
  validates :title, :presence => true, :on => :update
  validates :language, :presence => true

  attr_accessor :url

  before_create :get_video_info_from_url

  def to_s
    self.title
  end

  # Retrieve video information from youtube or vimeo
  def get_video_info_from_url
    if !self.url.nil?
      video = VideoInfo.new(self.url)
      if video.valid?
        self.title = video.title
        self.embed_thumbnail_url = video.thumbnail_small 
        self.embed_provider = video.provider.downcase
        self.embed_id = video.video_id
      end
    end
  end

  def self.per_page
    10
  end

end
