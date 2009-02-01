module ThinRest
  class Connection < Thin::Connection
    attr_reader :resource, :rack_request

    def process
      guard_against_errors do
        method = rack_request.request_method.downcase.to_sym
        @resource = get_resource
        resource.send(method)
      end
    end

    def rack_request
      @rack_request ||= Rack::Request.new(@request.env)
    end

    def send_head(status=200, additional_parameters={})
      send_data(head(status, additional_parameters))
    end

    def head(status, additional_parameters)
      parameters = {}
      parameters['Connection'] = "close" unless request.persistent?
      parameters.merge!(additional_parameters)
      head_output = parameters.inject("HTTP/1.1 #{status} OK\r\nServer: Thin Rest Server\r\n") do |header, parameter|
        header << "#{parameter[0]}: #{parameter[1]}\r\n"
      end
      if additional_parameters[:'Content-Length'] || additional_parameters['Content-Length']
        head_output << "\r\n"
      end
      head_output
    end

    def send_body(data)
      terminate_after_sending do
        send_data("Content-Length: #{data.length}\r\n\r\n")
        send_data(data)
        yield(self) if block_given?
      end
    end

    def terminate_after_sending
      yield
    ensure
      unless request.persistent?
        close_connection_after_writing
      end
      terminate_request
    end

    def unbind
      super
      resource.unbind if resource
    rescue Exception => e
      handle_error e
    end

    def terminate_request
      persistent = persistent?
      @resource = nil
      @rack_request = nil
      @request.close  rescue nil
      @response.close rescue nil

      # Prepare the connection for another request if the client
      # supports HTTP pipelining (persistent connection).
      if persistent
        post_init
      end
    end

    def persistent?
      request.persistent?
    end

    def handle_error(error)
      log_error error
      Resources::InternalError.new(:connection => self, :error => error).get
    rescue Exception => unexpected_error
      log_error unexpected_error
    end

    protected
    def guard_against_errors
      yield
    rescue RoutingError => e
      handle_error e
    rescue Exception => e
      wrapped_error = Exception.new("Error in #{rack_request.path_info} : #{e.message}")
      wrapped_error.set_backtrace(e.backtrace)
      handle_error wrapped_error
    end

    def get_resource
      path_parts.inject(root_resource) do |resource, child_resource_name|
        resource.locate(child_resource_name)
      end
    end

    def root_resource
      raise NotImplementedError
    end

    def path_parts
      rack_request.path_info.split('/').reject { |part| part == "" }
    end

    def error_message(e)
      output = "Error in Connection#receive_line\n"
      output << "#{e.message}\n"
      output << e.backtrace.join("\n\t")
      output << "\n\nResource was:\n\t"
      output << "#{resource.inspect}\n"
      output
    end
  end
end
