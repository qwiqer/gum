module Gum
  module Filters
    class Terms < Filter
      private

      def __render__(value)
        { terms: { field => [value].flatten } }
      end
    end
  end
end