module Gum
  module Filters
    class Regexp < Filter
      private

      def __render__(value)
        { regexp: { field => { value: value }.merge(options) } }
      end
    end
  end
end