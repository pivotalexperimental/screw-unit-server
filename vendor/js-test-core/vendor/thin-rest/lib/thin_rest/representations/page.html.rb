module Representations
  class Page < Erector::Widget
    def render(&block)
      rawtext %Q{<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">}
      html :xmlns => "http://www.w3.org/1999/xhtml", :"xml:lang" => "en" do
        head do
          meta :"http-equiv" => "Content-Type", :content => "text/html;charset=UTF-8"
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