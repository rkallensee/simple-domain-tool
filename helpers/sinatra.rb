helpers do
  # this is required to enable html_escape / h method
  include Rack::Utils
  alias_method :h, :escape_html
  
  def flash(msg)
    session[:flash] = msg
  end

  def show_flash
    if session[:flash]
      tmp = session[:flash]
      session[:flash] = false
      "<fieldset><legend>Notice</legend><p>#{tmp}</p></fieldset>"
    end
  end
end