class FeedUrl < ActiveRecord::Base
  stampable
  belongs_to :language
  validates :url, :presence => true
  validates :language_id, :presence => true

  scope :random, order("RAND()")
end
