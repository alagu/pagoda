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

      def base_url
        @base_url
      end

    end
  end
end
