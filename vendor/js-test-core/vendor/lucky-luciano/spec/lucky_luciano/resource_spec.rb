require File.expand_path("#{File.dirname(__FILE__)}/../spec_helper")

module LuckyLuciano
  module ResourceSpec
    class Root < Resource
      map "/"
    end

    class ResourceFixture < Resource
      map "/foobar"
    end

    class ResourceFixtureWithSubPaths < Resource
      map "/foobar/"

      get "/baz" do
        "Response from /foobar/baz"
      end

      get "/users/:user_id" do
        "User id is #{params[:user_id]}"
      end
    end

    class User < Resource
      map "/users/:user_id"

      get "/friends" do
        "User #{params['user_id']} friends"
      end
    end

    describe Resource do
      include ResourceSpec

      before do
        ResourceFixture.recorded_http_handlers.clear
      end

      macro("http verb") do |verb|
        describe ".#{verb}" do
          context "" do
            before do
              ResourceFixture.send(verb, "/") do
                "He sleeps with the fishes"
              end
            end
            
            it "creates a route to #{verb.upcase} the given path that executes the given block" do
              app.register(ResourceFixture.route_handler)
              response = send(verb, "/foobar")
              response.should be_http( 200, {}, "He sleeps with the fishes" )
            end
          end

          context "when the base path is blank and the relative path is blank" do
            before do
              Root.send(verb, "") do
                "Response from /"
              end
            end

            it "creates a route to /" do
              app.register(Root.route_handler)
              response = send(verb, "/")
              response.should be_http( 200, {}, "Response from /" )
            end
          end

          context "when the relative path does not have a leading slash" do
            before do
              ResourceFixtureWithSubPaths.send(verb, "no_leading_slash") do
                "Response from /foobar/no_leading_slash"
              end
            end

            it "creates a route to #{verb.upcase} the given path that executes the given block" do
              app.register(ResourceFixtureWithSubPaths.route_handler)
              response = send(verb, "/foobar/no_leading_slash")
              response.should be_http( 200, {}, "Response from /foobar/no_leading_slash" )
            end
          end


          it "does not respond to another type of http request" do
            ResourceFixture.send(verb, "/") do
              ""
            end
            app.register(ResourceFixture.route_handler)
            get("/foobar").status.should == 404 unless verb == "get"
            put("/foobar").status.should == 404 unless verb == "put"
            post("/foobar").status.should == 404 unless verb == "post"
            delete("/foobar").status.should == 404 unless verb == "delete"
          end

          describe "Instance behavior" do
            attr_reader :evaluation_target
            before do
              evaluation_target = nil
              ResourceFixture.send(verb, "/") do
                evaluation_target = self
                ""
              end
              app.register(ResourceFixture.route_handler)

              send(verb, "/foobar")
              @evaluation_target = evaluation_target
            end
            
            it "evaluates the block in as a Resource" do
              evaluation_target.class.should == ResourceFixture
            end

            it "sets app to be the Sinatra context" do
              evaluation_target.app.class.should == Sinatra::Application
            end

            it "delegates methods to the #app" do
              return_value = nil
              mock.proxy(evaluation_target.app).params {|val| return_value = val}
              evaluation_target.params.should == return_value
            end
            
            context "when the #app does not respond to the method" do
              it "raises a NoMethodError from the Resource's perspective" do
                lambda do
                  evaluation_target.i_dont_exist
                end.should raise_error(NoMethodError, /ResourceFixture/)
              end
            end
          end

        end
      end

      send("http verb", "get")
      send("http verb", "put")
      send("http verb", "post")
      send("http verb", "delete")

      describe ".[][]" do
        context "when passed nothing" do
          it "returns the base_path" do
            ResourceFixture[].should == "/foobar"
            ResourceFixture[][].should == "/foobar"
          end
        end

        context "when passed a sub path" do
          it "merges the base_path into the sub path, regardless of a / in front" do
            ResourceFixtureWithSubPaths["/baz"].to_s.should == "/foobar/baz"
            ResourceFixtureWithSubPaths["baz"].to_s.should == "/foobar/baz"
          end

          context "when passed a multiple sub paths" do
            it "joins the sub paths with '/'" do
              ResourceFixtureWithSubPaths["users"][99].should == "/foobar/users/99"
            end
          end

          context "when passed a hash as the last argument" do
            context "when using a single path argument" do
              it "creates url params from the hash" do
                path = ResourceFixtureWithSubPaths["/users/:user_id"][:user_id => 99, :single_value_param => "single_value_param_value", 'multiple_value_param[]' => [1,2,3]]
                path.should be_url("/foobar/users/99", [
                  "multiple_value_param[]=1",
                  "multiple_value_param[]=2",
                  "multiple_value_param[]=3",
                  "single_value_param=single_value_param_value",
                ])
              end
            end

            context "when using multiple path arguments" do
              it "creates url params from the hash" do
                path = ResourceFixtureWithSubPaths["users"][99][:single_value_param => "single_value_param_value", 'multiple_value_param[]' => [1,2,3]]
                path.should be_url("/foobar/users/99", [
                  "multiple_value_param[]=1",
                  "multiple_value_param[]=2",
                  "multiple_value_param[]=3",
                  "single_value_param=single_value_param_value",
                ])
              end
            end
            
            def be_url(expected_path, expected_query_parts)
              Spec::Matchers::SimpleMatcher.new("match url") do |actual|
                uri = URI.parse(actual.to_s)
                uri.path.should == expected_path
                query_parts = uri.query.split("&")
                query_parts.should =~ expected_query_parts
              end
            end
          end
        end
      end

      describe ".path" do
        context "when passed nothing" do
          it "returns the base_path" do
            ResourceFixture.path.should == "/foobar"
          end
        end
        
        context "when passed a sub path" do
          it "merges the base_path into the sub path, regardless of a / in front" do
            ResourceFixtureWithSubPaths.path("/baz").should == "/foobar/baz"
            ResourceFixtureWithSubPaths.path("baz").should == "/foobar/baz"
          end
          
          context "when passed a multiple sub paths" do
            it "joins the sub paths with '/'" do
              ResourceFixtureWithSubPaths.path("users", 99).should == "/foobar/users/99"
            end
          end

          context "when passed a hash as the last argument" do
            context "when using a single path argument" do
              it "creates url params from the hash" do
                path = ResourceFixtureWithSubPaths.path(
                  "/users/:user_id", {:user_id => 99, :single_value_param => "single_value_param_value", 'multiple_value_param[]' => [1,2,3]}
                )
                uri = URI.parse(path)
                uri.path.should == "/foobar/users/99"
                query_parts = uri.query.split("&")
                query_parts.should =~ [
                  "multiple_value_param[]=1",
                  "multiple_value_param[]=2",
                  "multiple_value_param[]=3",
                  "single_value_param=single_value_param_value",
                ]
              end
            end

            context "when using multiple path arguments" do
              it "creates url params from the hash" do
                path = ResourceFixtureWithSubPaths.path(
                  "users", 99, {:single_value_param => "single_value_param_value", 'multiple_value_param[]' => [1,2,3]}
                )
                uri = URI.parse(path)
                uri.path.should == "/foobar/users/99"
                query_parts = uri.query.split("&")
                query_parts.should =~ [
                  "multiple_value_param[]=1",
                  "multiple_value_param[]=2",
                  "multiple_value_param[]=3",
                  "single_value_param=single_value_param_value",
                ]
              end
            end
          end
        end
        
        context "when the base_path contains a parameter" do
          context "when not passed" do
            it "raises an ArgumentError" do
              lambda do
                User.path
              end.should raise_error(
                ArgumentError,
                %r{Expected :user_id to have a value}
              )
            end
          end

          context "when first argument is a hash" do
            it "returns the full path with the base path param value" do
              User.path("friends", :user_id => 99).should == "/users/99/friends"
            end
          end
        end
      end
    end
  end

end
