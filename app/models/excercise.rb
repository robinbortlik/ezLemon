class Excercise < ActiveRecord::Base
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::TagHelper
  
  EXCERCISE_TYPES = {1 => :fill_gaps, 2 => :translation}
  stampable
  record_activities :dependent => :destroy

  attr_accessor :pupils

  belongs_to :language
  has_many :excercises_results, :dependent => :destroy

  validates :language, :presence => true
  validates :pupils, :presence => true, :if => Proc.new{|e| !e.is_private?}
  validates :text, :presence => true
  validates :excercise_type, :presence => true

  after_create :prepare_results

  def self.per_page
    10
  end

   def to_s
    "#{I18n.l(created_at, :format => :short)} - #{language}"
  end

  def pupils
    @pupils || self.excercises_results.select("DISTINCT pupil_id").map(&:pupil_id)
  end

  # Prepare result for all excercise pupils.
  # If is excercise private, then prepare result only for creator
  def prepare_results
    transaction do
      if self.is_private?
        self.excercises_results.create(:pupil_id => User.stamper, :teacher_id => User.stamper)
      elsif pupils.any?
        pupils.each do |pupil_id|
          self.excercises_results.create(:pupil_id => pupil_id, :teacher_id => User.stamper)
        end
      end
    end
  end


  # Generate excercise dependent on excercise type
  def generate
    if language_id && excercise_type
      prepare_text
      self.generated = case excercise_type
      when 1 then prepare_fill_gaps
      when 2 then text
      end
    end
  end

  # Download RSS feed, sanitize content and create 4 paragraphs as text for excercise
  def prepare_text
    feed_url = FeedUrl.where(:language_id => language_id).order("RANDOM()").limit(1).first.try(:url)
    if feed_url && (feed = FeedNormalizer::FeedNormalizer.parse(feed_url))
      feed_text = feed.entries[0..3].map(&:content)
      self.text = ''
      feed_text.each do |ft|
        self.text += content_tag(:p, sanitize(HTMLEntities.new.decode(ft), :tags => "", :attributes => ""))
      end
    end
  end


  # Remove 10 words on random positions
  # Every removed word replace by <span class="blank-word">________</span> and blank position make droppable
  # Every removed word make draggable and put on the excercise bottom
  def prepare_fill_gaps
    excluded_words, excluded_indexes = [], []
    words = sanitize(HTMLEntities.new.decode(text)).split(" ")
    count_of_words = words.size
    10.times {excluded_indexes << rand(count_of_words).to_i}
    excluded_indexes.uniq.each do |i|
      word = sanitize(words[i], :tags => "", :attributes => "")
      words[i] = make_droppable_word
      excluded_words << make_draggable_word(word)
    end
    return words.join(" ") + " " + content_tag(:p, (I18n.t("excercises.move_word") + excluded_words.join(" &nbsp; ")).html_safe, :class => "selected-words" )
  end

  def make_droppable_word
    content_tag(:span, Excercise.spacer.html_safe, :class => "blank-word")
  end

  def self.spacer
    ('&nbsp;'*10)
  end

  def make_draggable_word(word)
    content_tag(:span, word, :class => "draggable-word")
  end
end
