module Mimo
  # A general MIMO exception
  class Error < StandardError; end
  class StandardError < Error
    attr_reader :action, :subject
    attr_writer :default_message

    def initialize(message = nil, action = nil, subject = nil)
      @message = message
      @action = action
      @subject = subject
      @default_message = I18n.t(:"splash.not_found", :default => "Not splash page found")
    end

    def to_s
      @message || @default_message
    end
  end
end
