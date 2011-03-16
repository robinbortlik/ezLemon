class Comment < ActiveRecord::Base
  stampable
  record_activities :dependent => :destroy
  belongs_to :commentable, :polymorphic => true
  default_scope :order => 'created_at ASC'

  validates :comment, :presence => true
  validates :commentable, :presence => true

  after_create :notify_user

  # If is commented excercise result and excercise is not private, then notify teacher or pupil.
  def notify_user
    if self.commentable.is_a?(ExcercisesResult)
      excercise = Excercise.find(self.commentable.excercise_id)
      unless excercise.is_private?
        user = (self.creator_id == self.commentable.teacher_id) ? self.commentable.pupil : self.commentable.teacher
        ApplicationMailer.new_excercise_comment(self.commentable,  user).deliver 
      end
    end
  end
  
end
