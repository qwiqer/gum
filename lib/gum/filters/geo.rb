module Gum
  module Filters
    class Geo
      def self.new(param, field, options)
        filter = const_get options.delete(:type).to_s.camelize
        filter.new param, field, options
      end
    end
  end
end