require 'redcloth'

#class TextileTemplateHandler < ActionView::TemplateHandlers::ERB
#  extend ActiveSupport::Memoizable
#  
#  def compile(template)
#    return super + ";redcloth = RedCloth.new(@output_buffer); redcloth.hard_breaks = false; redcloth.to_html;"
#  end
#end

module ActionView
  module Template::Handlers
    class TextileTemplateHandler
     
      def compile(template)
        return super + ";redcloth = RedCloth.new(@output_buffer); redcloth.hard_breaks = false; redcloth.to_html;"
      end

    end
  end
end

ActionView::Template.register_template_handler :red, ActionView::Template::Handlers::TextileTemplateHandler.new

