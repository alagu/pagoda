module Shwedagon
  module Views
    class NewPost < Layout
      attr_reader :ptitle

      def title
        @ptitle
      end

    end
  end
end