class ShowTestExceptions
  attr_reader :app

  def initialize(app)
    @app = app
  end

  def call(env)
    app.call(env)
  rescue StandardError, LoadError, SyntaxError => e
    body = [
        e.message,
        e.backtrace.join("\n\t")
      ].join("\n")
    [
      500,
      {"Content-Type" => "text",
       "Content-Length" => body.size.to_s},
      body
    ]
  end
end
