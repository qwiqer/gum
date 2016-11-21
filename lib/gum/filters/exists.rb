module Gum
  module Filters
    class Exists < Filter
      private

      FALSE_VALUES = [false, 0, '0', 'f', 'F', 'false', 'FALSE'].to_set

      def __render__(value)
        if value
          { exists: { field: field } }
        else
          { bool: { must_not: { exists: { field: field } } } }
        end
      end

      def value_from(params)
        !FALSE_VALUES.include?(super)
      end

      def empty?(value)
        value.nil? || value.try(:empty?)
      end
    end
  end
end