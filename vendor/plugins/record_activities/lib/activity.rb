class Activity < ActiveRecord::Base
  belongs_to :actor, :class_name => 'User'
  belongs_to :target, :class_name => 'User'
  belongs_to :subject, :polymorphic => true
  default_scope order('created_at DESC')
  validates :action, :presence => true

end