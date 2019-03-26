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
        return {} unless @is_parametric
        
        set_params(env['PATH_INFO'])
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

      def set_params(path)
        simpler_params = {}
        params_key = @path.split(':').last
        params_value = path.split('/').last
        simpler_params[params_key.to_sym] = params_value
      end

      def parametric?(path)
        path.include?(':')
      end
    end
  end
end
