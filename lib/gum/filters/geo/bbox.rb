module Gum
  module Filters
    class Geo
      class Bbox < Filter
        private

        def __render__(value)
          {
            geo_bounding_box: {
              field => {
                top: value.top,
                left: value.left,
                bottom: value.bottom,
                right: value.right
              }
            }
          }
        end

        def parser
          @_parser ||= ParamParser.new(options[:pattern])
        end

        def value_from(params)
          parser.parse(super)
        end

        def empty?(params)
          super || parser.empty?(params[param])
        end

        class ParamParser
          attr_reader :top, :left, :bottom, :right

          def initialize(order)
            @order = order || 'top,left,bottom,right'
            @regexp = regexp
          end

          def empty?(value)
            !@regexp.match(value)
          end

          def parse(value)
            match_data = @regexp.match(value)
            return unless match_data
            @top = match_data[:top].to_f
            @left = match_data[:left].to_f
            @bottom = match_data[:bottom].to_f
            @right = match_data[:right].to_f
            self
          end

          private

          def number_pattern
            '-?\\d{,3}\\.?\\d{,12}'
          end

          def regexp
            order = @order.split(',').map do |param|
              "(?<#{param}>#{number_pattern})"
            end.join(',')
            /^#{order}$/
          end
        end
      end
    end
  end
end