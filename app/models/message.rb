class Message < ActiveRecord::Base
  validates :sender_id, :presence => true
  validates :recipient_id, :presence => true
  validates :subject, :presence => true
  
  stampable
  belongs_to :sender, :class_name => 'User', :foreign_key => :sender_id
  belongs_to :recipient, :class_name => 'User', :foreign_key => :recipient_id

  scope :already_read, :conditions => "read_at IS NOT NULL"
  scope :unread, :conditions => "read_at IS NULL"

  def read?
    self.read_at.nil? ? false : true
  end

  def mark_deleted(user)
    self.sender_deleted = true if self.sender == user
    self.recipient_deleted = true if self.recipient == user
    self.sender_deleted && self.recipient_deleted ? self.destroy : save!
  end

  def read!
    self.update_attribute(:read_at, Time.now) unless self.read?
  end

  after_create :notify_recipient 
  after_save :update_user_counter_cache

  def notify_recipient
    ApplicationMailer.new_message(self).deliver
  end

  def update_user_counter_cache
    self.recipient.update_attribute(:new_messages_count, self.recipient.recieved_messages.unread.count)
  end
end