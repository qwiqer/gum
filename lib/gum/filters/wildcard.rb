module Gum
  module Filters
    class Wildcard < Filter
      private

      def __render__(value)
        if options[:boost]
          { wildcard: { field => { value: value, boost: options[:boost] } } }
        else
          { wildcard: { field => value } }
        end
      end
    end
  end
end