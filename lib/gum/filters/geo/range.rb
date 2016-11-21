module Gum
  module Filters
    class Geo
      class Range < Filter
        private

        def __render__(value)
          {
            geo_distance_range: {
              from: value[:from],
              to: value[:to],
              field => value[:lat_lon]
            }
          }
        end

        def value_from(params)
          {
            from: params[:"#{param}_from"],
            to: params[:"#{param}_to"],
            lat_lon: params[:"#{param}"]
          }
        end

        def empty?(params)
          params[:"#{param}"].blank? ||
            params[:"#{param}_from"].blank? ||
            params[:"#{param}_to"].blank?
        end
      end
    end
  end
end