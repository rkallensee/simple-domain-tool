helpers do
  # this is required to enable html_escape / h method
  include Rack::Utils
  alias_method :h, :escape_html

  def flash(msg)
    if session[:flash].nil?
      session[:flash] = Array.new
    end

    session[:flash] << msg
  end

  def show_flash
    unless session[:flash].nil?
      flashes = "<ul>"
      session[:flash].each do |flash|
        flashes << "<li><strong>#{flash}</strong></li>"
      end
      flashes << "</ul>"
      session[:flash] = nil
      "<div class=\"alert alert-error\">
        <a class=\"close\" href=\"#\">&times;</a>
        #{flashes}
      </div>"
    end
  end
end