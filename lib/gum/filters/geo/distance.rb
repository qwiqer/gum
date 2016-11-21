module Gum
  module Filters
    class Geo
      class Distance < Filter
        private

        def __render__(value)
          {
            geo_distance: {
              distance: value[:distance],
              field => value[:lat_lon]
            }
          }
        end

        def value_from(params)
          return nil unless params[:"#{param}"].present? && params[:"#{param}_distance"].present?
          {
            distance: params[:"#{param}_distance"],
            lat_lon: params[:"#{param}"]
          }
        end
      end
    end
  end
end