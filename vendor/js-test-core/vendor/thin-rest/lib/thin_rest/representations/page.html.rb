module Representations
  class Page < Erector::Widget
    def render(&block)
      html do
        head do
          title
          script_elements
          link_elements
        end
        body do
          body_content(&block)
        end
      end
    end

    protected
    def body_content(&block)
      yield(self)
    end

    def path
      helpers.rack_request.path_info
    end

    def title
      element("title", "Thin Rest")
    end

    def script_elements
    end

    def link_elements
    end
  end
end