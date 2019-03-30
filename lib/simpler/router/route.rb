module Simpler
  class Router
    class Route
      attr_reader :controller, :action

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
        @is_parametric = parametric?(@path)
      end

      def match?(method, path)
        @method == method && path?(path)
      end

      def params(request)
        return {} unless @is_parametric

        extract_params(request.path)
      end

      private

      def path?(path)
        return true if path == @path

        parametric_path?(path)
      end

      def parametric_path?(path)
        requested_path = path.split('/')
        route_path = @path.split('/')

        return false unless requested_path.count == route_path.count

        route_path.each_with_index.all? do |route_path_part, index|
          route_path_part == requested_path[index] || parametric?(route_path_part)
        end
      end

      def extract_params(path)
        requested_path = path.split('/')
        route_path = @path.split('/')
        route_path.each.with_index.with_object({}) do |(route_part, index), result|
          next if route_part == requested_path[index]
          
          result[route_part.delete(':').to_sym] = requested_path[index]
        end
      end

      def parametric?(path)
        path.include?(':')
      end
    end
  end
end
