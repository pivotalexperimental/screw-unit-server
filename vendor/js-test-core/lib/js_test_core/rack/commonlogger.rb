Rack::CommonLogger.class_eval do
  def empty?
    @body.empty?
  end
end
