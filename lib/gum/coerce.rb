module Gum
  module Coerce
    FALSE_VALUES = [false, 0, '0', 'f', 'F', 'false', 'FALSE'].to_set

    module_function

    def range(attr, params)
      key_from = :"#{attr}_from"
      key_to = :"#{attr}_to"

      return unless params.values_at(key_from, key_to).all?

      yield(gte: params[key_from], lte: params[key_to])
    end

    def term(attr, params)
      return if params[attr].blank?

      yield params[attr]
    end

    def terms(attr, params)
      return if params[attr].blank?

      if params[attr].is_a?(Array)
        yield params[attr]
      elsif params[attr].is_a?(String)
        yield params[attr].split(',')
      else
        raise ArgumentError, 'Terms should be either Array or String'
      end
    end

    def exists(attr, params)
      return if params[attr].eql?('')

      yield !FALSE_VALUES.include?(params[attr])
    end

    def split(attr, params, separator: '-', default: nil)
      return if params[attr].blank?

      value, option = params[attr].split(separator, 2)
      option ||= default.presence

      return if value.blank? || option.blank?

      yield value, option
    end
  end
end
