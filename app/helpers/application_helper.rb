module ApplicationHelper

  def flash_messages
    "#{content_tag(:p, notice, :class => "notice flash-message")  if notice}
    #{content_tag(:p, alert, :class => "alert flash-message")  if alert}".html_safe
  end

  def scribd_hint
    "#{link_to(t(:scribd_terms), "http://support.scribd.com/entries/25459-general-terms-of-use", {:target => "_blank"})}
        #{link_to(t(:scribd_policity), "http://support.scribd.com/entries/25580-privacy-policy", {:target => "_blank"})}".html_safe
  end

  def multiselect_js
    javascript_include_tag("jquery.scrollTo-min", "ui.multiselect") +
      javascript_tag("$(function(){
        $('.multiselect').multiselect();
      });
      ")
  end

  def skype_button(user)
    unless user.skype_name.blank?
      javascript_include_tag("http://download.skype.com/share/skypebuttons/js/skypeCheck.js") +
        link_to("skype:#{user.skype_name}?call") do
        image_tag("http://mystatus.skype.com/balloon/#{user.skype_name}", :class=> "skype-button")
      end
    end
  end

  def icon(name)
    "<div class='ui-silk ui-silk-#{name}'>&nbsp;</div>".html_safe
  end

  def active_class(name=[])
    name = Array.wrap(name)
    "class='active'" if controller.controller_name =~ /#{name.collect{|n| n}.join("|")}/
  end

  def activity_icon(activity)
    case activity.subject.class.name
      when 'Comment', 'ForumPost' then icon('comment')
      when 'Video' then icon('television')
      when 'Document' then icon('page-white-acrobat')
      when 'Excercise' then icon('application-edit')
      when 'ExcercisesResult' then icon('lightbulb')
      when 'Meeting' then icon('date')
      when 'MeetingsUser' then icon('skype')
    end
  end

  def title(translate = 'title')
    content_for(:head_title){" - " + t(".#{translate}")}
  end

  def description
    content_for(:meta_description){t('.meta_description')}
  end
end
