module Selenium
  module Client
    Driver.class_eval do
      attr_reader :session_id
    end
  end
end