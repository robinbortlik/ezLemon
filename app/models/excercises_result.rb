class ExcercisesResult < ActiveRecord::Base
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::TagHelper
  
  acts_as_commentable
  stampable
  record_activities :dependent => :destroy

  belongs_to :excercise
  belongs_to :teacher, :class_name => "User", :foreign_key => :teacher_id
  belongs_to :pupil, :class_name => "User", :foreign_key => :pupil_id

  validates :excercise_id, :presence => true
  validates :teacher_id, :presence => true
  validates :pupil_id, :presence => true

  before_save :compare_result, :finished_if_result, :on => :update

  after_create :notify_user
  after_save :update_user_counter_cache

  def self.per_page
    10
  end

  def to_s
    "#{excercise}"
  end

  # Compare excercise result dependent on excercise type
  def compare_result
    case excercise.excercise_type
    when 1 then compare_fill_gaps
    end
    return true
  end

  # Mark result as finished if result is not blank.
  # Be careful to always return true in before_save.
  def finished_if_result
    self.is_finished = !result.blank?
    return true
  end

  def target
    self.id_changed? ? self.pupil_id : self.teacher_id
  end

  # This method compare the result for excercise type Fill gaps
  # First, it split original text to the words. After that, it gsub the blank positions and splits result to the words.
  # Then it compare word after word and ask if the words are equal. If not, then it replace the mistake with <span class="misatke">word</span>.
  def compare_fill_gaps
    if !result.blank?
      text_paragraphs = HTMLEntities.new.decode(excercise.text).split(/<\/p>/) # split original text to paragramph
      result_paragraphs = HTMLEntities.new.decode(result)
      result_paragraphs.gsub!(/<span(.+?)<\/span>/, " - ") # replace blank possitions with " - "
      result_paragraphs = result_paragraphs.split(/<\/p>/) # split user result to paragraphs
      result_paragraphs.pop  #remove draggable words
      self.mistakes_count = 0
      
      total_result = []
      text_paragraphs.each_with_index do |p, i|
        text_words = sanitize(p, :tags => "", :attributes => "").split(" ")
        result_words = sanitize(result_paragraphs[i], :tags => "", :attributes => "").split(" ")

        text_words.each_with_index do |text_word, index|
          word = result_words[index]

          # If words on the same position are not equals, then replace it by <span class="mistake">word</span> and increment count of mistakes
          if !word.eql?(text_word)
            result_words[index] = content_tag(:span, word, :class => "mistake")
            self.mistakes_count += 1
          end
        end
        total_result << content_tag(:p, result_words.join(" "))
      end

      self.result = total_result.join(" ")
    else
      self.mistakes_count = nil
      self.result = nil
    end
  end

  # Notify user, that teacher created excercise for him
  def notify_user
    ApplicationMailer.new_excercise(self).deliver
  end

  # Cache the count of unfinished excercises
  def update_user_counter_cache
    self.pupil.update_attribute(:unfinished_excercises_count, ExcercisesResult.where(:pupil_id => self.pupil, :is_finished => false).count)
  end

end
