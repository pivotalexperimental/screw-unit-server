require "time"
class Time
  def rfc822
    strftime("%a, %d %b %Y %k:%M:%S %Z")
  end  
end