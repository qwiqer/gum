module Gum
  module Filters
    class Range < Filter
      private

      def __render__(value)
        { range: { field => value.update(options) } }
      end

      def value_from(params)
        {
          gte: params[:"#{param}_from"],
          lte: params[:"#{param}_to"]
        }
      end

      def empty?(params)
        params[:"#{param}_from"].blank? || params[:"#{param}_to"].blank?
      end
    end
  end
end