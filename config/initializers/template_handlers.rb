require 'redcloth'

module ActionView
  module Template::Handlers
    class TextileTemplateHandler < ActionView::Template::Handlers::ERB
     extend ActiveSupport::Memoizable
     
      def compile(template)
        return super + ";redcloth = RedCloth.new(@output_buffer); redcloth.hard_breaks = false; redcloth.to_html;"
      end
    end
  end
end

ActionView::Template.register_template_handler :red, ActionView::Template::Handlers::TextileTemplateHandler.new

