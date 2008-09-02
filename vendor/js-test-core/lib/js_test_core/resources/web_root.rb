module JsTestCore
  module Resources
    class WebRoot < ThinRest::Resource
      route "" do |env, name|
        self
      end
      route "core" do |env, name|
        Resources::Dir.new(env.merge(
          :absolute_path => JsTestCore::Server.core_path,
          :relative_path => "/core"
        ))
      end
      route "implementations" do |env, name|
        Resources::Dir.new(env.merge(
          :absolute_path => JsTestCore::Server.implementation_root_path,
          :relative_path => "/implementations"
        ))
      end
      route "suites", "JsTestCore::Resources::Suite::Collection"
      route "runners", "JsTestCore::Resources::Runner::Collection"
      route "specs" do |env, name|
        if self.class.dispatch_strategy == :specs
          Resources::Specs::SpecDir.new(env.merge(
            :absolute_path => JsTestCore::Server.spec_root_path,
            :relative_path => "/specs"
          ))
        else
          Resources::FileNotFound.new(env.merge(:name => name))
        end
      end
      route ANY do |env, name|
        potential_file_in_public_path = "#{public_path}/#{name}"
        if ::File.directory?(potential_file_in_public_path)
          Resources::Dir.new(env.merge(
            :absolute_path => potential_file_in_public_path,
            :relative_path => "/#{name}"
          ))
        elsif ::File.exists?(potential_file_in_public_path)
          Resources::File.new(env.merge(
            :absolute_path => potential_file_in_public_path,
            :relative_path => "/#{name}"
          ))
        else
          Resources::FileNotFound.new(env.merge(:name => name))
        end
      end

      class << self
        attr_accessor :dispatch_strategy
        def dispatch_specs
          self.dispatch_strategy = :specs
        end
      end

      property :public_path

      def get
        connection.send_head(301, :Location => "/#{self.class.dispatch_strategy}")
        connection.send_body("<script type='text/javascript'>window.location.href='/specs';</script>")
      end
    end
  end
end