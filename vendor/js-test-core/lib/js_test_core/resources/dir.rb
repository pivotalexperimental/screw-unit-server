module JsTestCore
  module Resources
    class Dir < File
      get "*" do
        pass unless ::File.directory?(absolute_path)

        Representations::Dir.new(:relative_path => relative_path, :absolute_path => absolute_path).to_s
      end
    end
  end
end