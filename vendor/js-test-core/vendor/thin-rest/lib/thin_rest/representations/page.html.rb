module Representations
  class Page < Erector::Widget
    def render(&block)
      html do
        head do
          title
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
  end
end