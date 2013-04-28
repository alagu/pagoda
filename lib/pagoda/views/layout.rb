require 'cgi'

module Shwedagon
  module Views
    class Layout < Mustache
      include Rack::Utils
      alias_method :h, :escape_html

      attr_reader :name, :path

      def title
        "Home"
      end

    end
  end
end
