class TranslatorController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @translator = Google::Translator.new
  end

  def translate
    if !params[:from].blank? && !params[:to].blank? && !params[:text].blank?
        @translator = Google::Translator.new
      begin
        @translated_text = @translator.translate(params[:from], params[:to], params[:text])
      rescue Google::Translator::InvalidResponse
        return render :inline => "alert('#{t(:error, :scope => [:flash, :actions, :translate])}')"
      end
    end
  end
end
