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
	  "<div class=\"alert-message error\">
        <a class=\"close\" href=\"#\">&times;</a>
        <p><strong>#{tmp}</p>
      </div>"
    end
  end
end