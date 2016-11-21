module Gum
  module Filters
    class Term < Filter
      private

      def __render__(value)
        if options[:boost]
          { term: { field => { value: value, boost: options[:boost] } } }
        else
          { term: { field => value } }
        end
      end
    end
  end
end