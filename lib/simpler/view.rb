require 'erb'

module Simpler
  class View
    VIEW_BASE_PATH = 'app/views'.freeze

    def initialize(env)
      @env = env
    end

    def render(binding)
      if template.is_a?(Hash)
        render_plain(template[:plain])
      else
        render_erb(binding)
      end
    end

    private

    def render_erb(binding)
      template = File.read(template_path)

      ERB.new(template).result(binding)
    end

    def render_plain(text)
      text + "\n"
    end

    def controller
      @env['simpler.controller']
    end

    def action
      @env['simpler.action']
    end

    def template
      @env['simpler.template']
    end

    def template_path
      path = template || [controller.name, action].join('/')

      Simpler.root.join(VIEW_BASE_PATH, "#{path}.html.erb")
    end

  end
end
