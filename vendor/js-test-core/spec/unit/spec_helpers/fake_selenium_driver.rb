class FakeSeleniumDriver
  SESSION_ID = "DEADBEEF"
  attr_reader :session_id

  def initialize
    @session_id = nil
  end

  def start
    @session_id = SESSION_ID
  end

  def stop
    @session_id = nil
  end

  def open(url)
  end

  def create_cookie(key_value, options="")

  end

  def session_started?
    !!@session_id
  end
end
