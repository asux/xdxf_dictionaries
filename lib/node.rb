module Nokogiri
  module XML
    class Node

      # Returns first node finded by +text()+ XPath function
      def text
        self.xpath('text()').first
      end

      # Returns text node or content
      def text_or_content
        t = self.text
        t.blank? ? self.content : t.to_s
      end

      # Returns text node or inner html
      def text_or_inner_html
        t = self.text
        t.blank? ? self.inner_html : t.to_s
      end

    end
  end
end
