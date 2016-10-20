module Gum
  module Filters
    module_function

    def range(attr, flags = {})
      lambda do |params|
        attr_from = params["#{attr}_from"]
        attr_to = params["#{attr}_to"]
        return if attr_from.blank? && attr_to.blank?
        Coerce.range(attr, params) do |value|
          { range: { attr => value.update(flags) } }
        end
      end
    end

    def term(attr, flags = {})
      lambda do |params|
        Coerce.term(attr, params) do |value|
          if flags[:boost]
            { term: { attr => { value: value, boost: flags[:boost] } } }
          else
            { term: { attr => value }.update(flags) }
          end
        end
      end
    end

    def terms(attr, _flags = {})
      lambda do |params|
        Coerce.terms(attr, params) do |value|
          { terms: { attr => value } }
        end
      end
    end

    def exists(attr, _flags = {})
      lambda do |params|
        Coerce.exists(attr, params) do |value|
          if value
            { exists: { field: attr } }
          else
            { bool: { must_not: { exists: { field: attr } } } }
          end
        end
      end
    end

    def prefix(attr, flags = {})
      lambda do |params|
        Coerce.term(attr, params) do |value|
          { prefix: { attr => value }.update(flags) }
        end
      end
    end

    def wildcard(attr, flags = {})
      lambda do |params|
        Coerce.term(attr, params) do |value|
          { wildcard: { attr => value }.update(flags) }
        end
      end
    end

    def regexp(attr, flags = {})
      lambda do |params|
        Coerce.term(attr, params) do |value|
          { regexp: flags.update(attr => value) }
        end
      end
    end

    def fuzzy(attr, separator: '_', **flags)
      lambda do |params|
        Coerce.split(attr, params, separator: separator, default: flags[:fuzziness]) do |value, fuzziness|
          { fuzzy: { attr => { value: value, fuzziness: fuzziness }.update(flags) } }
        end
      end
    end

    def default_range_result(attr_from, attr_to)
      {
        range: {
          attr => {
            gte: attr_from,
            lte: attr_to
          }
        }
      }
    end
  end
end
