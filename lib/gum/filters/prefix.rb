module Gum
  module Filters
    class Prefix < Filter
      private

      def __render__(value)
        if options[:boost]
          { prefix: { field => { value: value, boost: options[:boost] } } }
        else
          { prefix: { field => value } }
        end
      end
    end
  end
end