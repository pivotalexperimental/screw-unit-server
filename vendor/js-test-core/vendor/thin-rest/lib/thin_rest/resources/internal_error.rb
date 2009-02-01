module ThinRest
  module Resources
    class InternalError < Resource
      property :error
      def get
        connection.send_head(500)
        connection.send_body(Representations::InternalError.new(self, :error => error).to_s)
      end
    end
  end
end