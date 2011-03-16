class Document < ActiveRecord::Base
  attr_accessor :accept_scribd_terms

  stampable
  record_activities :dependent => :destroy
  acts_as_commentable

  has_attached_file :document, switch_storage
  belongs_to :language
  validates_attachment_presence :document
  has_ipaper_and_uses 'Paperclip'

  validates :title, :presence => true
  validates :language, :presence => true
  validates :accept_scribd_terms, :acceptance => true

  def to_s
    self.title
  end

  def self.per_page
    10
  end

end
