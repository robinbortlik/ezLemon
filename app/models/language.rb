class Language < ActiveRecord::Base
  APPLICATION_LANGUAGES = ["CS", "EN"]
  stampable
  has_many :documents
  has_many :teaching_language_users, :dependent => :destroy
  has_many :learning_language_users, :dependent => :destroy
  has_many :feed_urls
  validates :code, :presence => true, :uniqueness => true

  scope :available_excercise, where("languages.id = feed_urls.language_id").joins(:feed_urls).select("DISTINCT languages.*")
  scope :application, where(:code => APPLICATION_LANGUAGES)

  def to_s
    language_name_from_code.capitalize
  end

  alias name to_s

  def language_name_from_code
    self.class.language_name_from_code(code)
  end

  def self.language_name_from_code(code)
    I18nData.languages(I18n.locale).try(:[], code).try(:split,";").try(:first)
  end

  def self.sorted_languages
    with_scope do
      all.collect{|l| [l.language_name_from_code, l.id]}.sort_alphabetical_by(&:first)
    end
  end

end
