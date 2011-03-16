module EmbedPlayerHelper

  FLASH_REQUIRED_MESSAGE =  %(You must enable JavaScript and install the <a href="http://www.adobe.com/go/getflashplayer">Adobe Flash</a> plugin to view this player)

  DEFAULT_FLASH_OPTIONS = {
    :id                     => 'flash_player',
    :allowfullscreen        => 'true',
    :allowscriptaccess      => 'true',
    #:play                   => 'true',
    #:menu                   => 'false',
    #:quality                => 'autohigh',
    #:scale                  => 'default',
    #:wmode                  => 'opaque',
    :width                  => 640,
    :height                 => 390
  }

   DEFAULT_EMBED_PLAYER_OPTIONS = {
    :youtube => {
      
    },
    :vimeo => {
      :server => "vimeo.com",
      :show_title => 0,
      :show_byline => 0,
      :show_portrait => 0,
      :color => 879096,
      :fullscreen => 1
    }
  }


   def embed_player(provider, id, flash_options = {}, embed_player_options = {})
    provider = provider.to_sym
    flash_options = DEFAULT_FLASH_OPTIONS.merge(flash_options)
    embed_player_options = DEFAULT_EMBED_PLAYER_OPTIONS[provider].merge(embed_player_options)

    provider_url = case provider
    when :youtube
      "http://www.youtube.com/v/#{id}?version=3"
    when :vimeo
      "http://vimeo.com/moogaloop.swf?clip_id=#{id}"
    end

    js = "swfobject.embedSWF('#{provider_url}','#{flash_options[:id]}','#{flash_options[:width]}','#{flash_options[:height]}','9.0.0','/flash/expressInstall.swf',"
    js << options_for_swfobject(embed_player_options, flash_options)
    content_tag('div', FLASH_REQUIRED_MESSAGE, :id => flash_options[:id]) << javascript_tag(js)
  end

  protected

  def swfobject_params(options)
    "{#{options.collect{ |k,v| "'#{k.to_s}':'#{v.to_s}'" }.join(',')}},"
  end

  def options_for_swfobject(player_options, flash_options)
    options = flash_options.dup
    [:id, :width, :height].each{|key| options.delete(key)}
    flash_script  = swfobject_params(player_options)
    flash_script << swfobject_params(flash_options)
    flash_script << "{});"
  end

end