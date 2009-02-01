module Representations
  class ResourceNotFound < Page
    protected
    def body_content
      h1 message
    end

    def title
      element("title", message)
    end

    def message
      "File #{path} not found"
    end
  end
end