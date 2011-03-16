class User < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  
  # Setup accessible (or protected) attributes for your model
  attr_accessor :profile_tab
  attr_accessible :email, :password, :password_confirmation, :name, :avatar, :skype_name,
    :learning_language_ids, :teaching_language_ids, :application_language_code,
    :time_zone, :profile_tab, :interests

  acts_as_commentable
  
  model_stamper
  stampable

  has_attached_file :avatar, switch_storage(:styles => {:original => "100x100#", :small => "32x32#"})
  has_many :videos, :foreign_key => 'creator_id'
  has_many :documents, :foreign_key => 'creator_id'
  has_many :pupils_teachers, :dependent => :destroy, :class_name => 'PupilsTeacher', :foreign_key => 'pupil_id'
  has_many :teachers_pupils, :dependent => :destroy, :class_name => 'PupilsTeacher', :foreign_key => 'teacher_id'
  has_many :teachers, :through => :pupils_teachers, :source => :teacher, :select => "DISTINCT users.*" # PUPIL HAVE TEACHERS
  has_many :pupils, :through => :teachers_pupils, :source => :pupil, :select => "DISTINCT users.*"  # TEACHER HAVE PUPILS
  has_many :learning_language_users
  has_many :teaching_language_users
  has_many :learning_languages, :through => :learning_language_users, :source => :language
  has_many :teaching_languages, :through => :teaching_language_users, :source => :language
  has_many :sent_messages, :class_name => 'Message', :foreign_key => :sender_id, :conditions => {:sender_deleted => false}
  has_many :recieved_messages, :class_name => 'Message', :foreign_key => :recipient_id, :conditions => {:recipient_deleted => false}
  has_many :activities, :dependent => :destroy, :foreign_key => :actor_id
  has_many :excercises, :foreign_key => :creator_id
  has_many :excercises_results, :dependent => :destroy, :foreign_key => "pupil_id"
  has_many :meetings, :dependent => :destroy
  has_many :meetings_users, :dependent => :destroy

  scope :except_user, lambda{|user| where(["users.id <> ?", user])}
  validates :application_language_code, :presence => true
  validates :time_zone, :presence => true

  def to_s
    name.blank? ? resolve_name_from_email : name
  end

  def resolve_name_from_email
    "#{email.try(:split,"@").try(:first)}"
  end

  def languages_codes(type)
    case type
    when :learning then learning_languages.all(:select => :code).collect{|l| l.code}
    when :teaching then teaching_languages.all(:select => :code).collect{|l| l.code}
    end
  end

  def small_avatar_url
    avatar.url(:small)
  end

  def assigned_user_ids
    (teacher_ids + pupil_ids).push(id)
  end

  # Users would not type password every profile change.
  def update_with_password(params={})
    if params[:password].blank?
      params.delete(:password)
      params.delete(:password_confirmation) if params[:password_confirmation].blank?
    end
    update_attributes(params)
  end


end
