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

      def params(env)
        return env['simpler.route_params'] = {} unless @is_parametric

        extract_params(env)
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

      def extract_params(env)
        env['simpler.route_params'] = {}
        requested_path = env['PATH_INFO'].split('/')
        route_path = @path.split('/')
        route_path.each_with_index do |route_path_part, index|
          next if route_path_part == requested_path[index]

          key = route_path_part.delete(':').to_sym
          value = requested_path[index]
          env['simpler.route_params'] = env['simpler.route_params'].merge({ key => value })
        end
      end

      def parametric?(path)
        path.include?(':')
      end
    end
  end
end
