module PinItButton
  PINTEREST_SHARE_URL = "http://pinterest.com/pin/create/button"

  class <<self
     attr_accessor :default_pin_button_options
     attr_accessor :default_pin_button_html_options
  end

  def pin_it_button(options = {}, html_options = {})
    params = pin_options_to_query_string(default_pin_button_options.merge(options))
    html_opts = default_pin_button_html_options.merge(options)

    html = pin_html_safe_string('')
    
    # adding it all together to create the link
    html << link_to("Pin it", pin_html_safe_string(params), html_opts)
    
    # adding the js script
    unless @pinified
      html << pinterest_widgets_js_tag
    end
  end
  
  def default_pin_button_html_options
    {
      :class => 'pin-it-button',
      :'count-layout' => 'vertical'
    }.merge(PinItButton.default_pin_button_html_options || {})
  end
  
  def default_pin_button_options
    {
      :description => request.url,
      :media => '',
      :url => request.url
    }.merge(PinItButton.default_pin_button_options || {})
  end
  
  def pin_options_to_query_string(opts)
     opts.map{|k,v| "#{CGI.escape(k.to_s)}=#{CGI.escape(v)}"}.join("&")
  end
  
  def pinterest_widgets_js_tag
    @pinified = true
    pin_html_safe_string('<script type="text/javascript" src="http://assets.pinterest.com/js/pinit.js"></script>')
  end

  def pin_html_safe_string(str)
    @pin_use_html_safe ||= "".respond_to?(:html_safe)
    @pin_use_html_safe ? str.html_safe : str
  end
  
end