class CustomException < StandardError
  attr_reader :action, :subject
  attr_writer :default_message

  def initialize(message = nil, action = nil, subject = nil)
    @message = message
    @action = action
    @subject = subject
    @default_message = I18n.t(:"splash.default", :default => "No splash page found")
  end

  def to_s
    @message || @default_message
  end
end
