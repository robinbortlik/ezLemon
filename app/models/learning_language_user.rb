class LearningLanguageUser < ActiveRecord::Base
  stampable
  belongs_to :user
  belongs_to :language
  validates :user_id, :presence => true, :uniqueness => {:scope => :language_id}
  validates :language_id, :presence => true
end
