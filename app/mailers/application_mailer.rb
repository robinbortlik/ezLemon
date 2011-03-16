class ApplicationMailer < ActionMailer::Base
  layout 'email'
  default :from => "ezLemon <info@ezlemon.com>", :content_type => "text/html"
  
  def new_message(message)
    @message = message
    mail(:to => message.recipient.email, :subject => I18n.t("application_mailer.new_message.subject"))
  end

  def new_meeting(meeting, user)
    @meeting = meeting
    @user = user
    mail(:to => user.email, :subject => I18n.t("application_mailer.new_meeting.subject"))
  end

  def new_excercise_comment(excercises_result, user)
    @excercises_result = excercises_result
    @user = user
    mail(:to => user.email, :subject => I18n.t("application_mailer.new_excercise_comment.subject"))
  end

  def new_excercise(excercises_result)
    @excercises_result = excercises_result
    mail(:to => excercises_result.pupil.email, :subject => I18n.t("application_mailer.new_excercise.subject"))
  end

end
