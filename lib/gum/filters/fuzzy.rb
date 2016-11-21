module Gum
  module Filters
    class Fuzzy < Filter
      private

      def __render__(value)
        { fuzzy: { field => { value: value }.merge(options) } }
      end
    end
  end
end