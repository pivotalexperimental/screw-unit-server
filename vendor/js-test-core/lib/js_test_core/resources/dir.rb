module JsTestCore
  module Resources
    class Dir < File
      route ANY do |env, name|
        if file = file(name)
          file
        elsif subdir = subdir(name)
          subdir
        else
          FileNotFound.new(env.merge(:name => name))
        end
      end

      def get
        connection.send_head
        connection.send_body(::Dir.glob("#{absolute_path}/*").inject("") do |html, file|
          file_basename = ::File.basename(file)
          html << %Q|<a href="#{file_basename}">#{file_basename}</a>\n|
        end)
      end

      def glob(pattern)
        expanded_pattern = absolute_path + pattern
        ::Dir.glob(expanded_pattern).map do |absolute_globbed_path|
          relative_globbed_path = absolute_globbed_path.gsub(absolute_path, relative_path)
          File.new(env.merge(
            :absolute_path => absolute_globbed_path,
            :relative_path => relative_globbed_path
          ))
        end
      end

      protected
      def determine_child_paths(name)
        absolute_child_path = "#{absolute_path}/#{name}"
        relative_child_path = "#{relative_path}/#{name}"
        [absolute_child_path, relative_child_path]
      end

      def file(name)
        # N.B. Absolute_path and relative_path are methods. Do not shadow.
        absolute_file_path, relative_file_path = determine_child_paths(name)
        if ::File.exists?(absolute_file_path) && !::File.directory?(absolute_file_path)
          Resources::File.new(env.merge(
            :absolute_path => absolute_file_path,
            :relative_path => relative_file_path
          ))
        else
          nil
        end
      end

      def subdir(name)
        # N.B. Absolute_path and relative_path are methods. Do not shadow.
        absolute_dir_path, relative_dir_path = determine_child_paths(name)
        if ::File.directory?(absolute_dir_path)
          Resources::Dir.new(env.merge(
            :absolute_path => absolute_dir_path,
            :relative_path => relative_dir_path
          ))
        else
          nil
        end
      end
    end
  end
end