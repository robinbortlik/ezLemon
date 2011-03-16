class MeetingsUser < ActiveRecord::Base
  stampable
  belongs_to :meeting
  belongs_to :user
  validates :user_id, :presence => true, :uniqueness => {:scope => :meeting_id}
  validates :meeting_id, :presence => true
  record_activities :dependent => :destroy
end