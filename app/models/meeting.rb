class Meeting < ActiveRecord::Base
  validates :datetime_from, :presence => true
  validates :datetime_to, :presence => true
  validates :user_id, :presence => true
  
  stampable
  belongs_to :user
  has_many :meetings_users, :dependent => :destroy
  has_many :users, :through => :meetings_users
  scope :in_date_range, lambda {|from, to| where(["datetime_from >= ? AND datetime_to <= ?", from.beginning_of_day, to.end_of_day])}
  scope :for_user, lambda{|user| where(:user_id => user.assigned_user_ids)}
  record_activities :dependent => :destroy

  after_create :creator_is_attending, :notify_user, :increment_user_counter_cache
  
  def to_s(format = :short)
    I18n.t(:meeting, :scope => [:activerecord, :models]) + " - #{I18n.l(datetime_from, :format => format)} - #{I18n.l(datetime_to, :format => format)}"
  end


  def creator_is_attending
    meetings_users.create!(:user_id => user_id)
  end

  def readonly_meeting?(user)
    user.id != user_id
  end

  def notify_user
    (self.user.teachers + self.user.pupils).each do |user|
      ApplicationMailer.new_meeting(self, user).deliver
    end
  end

  def increment_user_counter_cache
    (self.user.teachers + self.user.pupils).each do |user|
      user.increment!(:unviewed_meetings_count)
    end
  end
end