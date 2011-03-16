class PupilsTeacher < ActiveRecord::Base
  belongs_to :pupil, :class_name => 'User', :foreign_key => 'pupil_id'
  belongs_to :teacher, :class_name => 'User', :foreign_key => 'teacher_id'
  belongs_to :language
  validates :pupil_id, :presence => true, :uniqueness => {:scope => [:teacher_id, :language_id] }
  validates :teacher_id, :presence => true
end
