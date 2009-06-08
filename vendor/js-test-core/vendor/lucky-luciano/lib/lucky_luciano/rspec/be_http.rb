module BeHttp
  include Spec::Matchers
  def be_http(status, headers, body)
    SimpleMatcher.new(nil) do |given, matcher|
      description = (<<-DESC).gsub(/^ +/, "")
      be an http of
      expected status: #{status.inspect}
      actual status  : #{given.status.inspect}

      expected headers containing: #{headers.inspect}
      actual headers             : #{given.headers.inspect}

      expected body containing: #{body.inspect}
      actual body             : #{given.body.inspect}
      DESC
      matcher.failure_message = description
      matcher.negative_failure_message = "not #{description}"

      passed = true
      unless given.status == status
        passed = false
      end
      unless headers.all?{|k, v| given.headers[k] == headers[k]}
        passed = false
      end
      unless body.is_a?(Regexp) ? given.body =~ body : given.body.include?(body)
        passed = false
      end
      passed
    end
  end
end