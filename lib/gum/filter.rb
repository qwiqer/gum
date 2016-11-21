module Gum
  class Filter
    attr_reader :param, :field, :options

    def initialize(param, field, options)
      @param = param
      @field = field
      @options = options || {}
    end

    def render(params)
      return if empty?(params)
      __render__ value_from(params)
    end

    def value_from(params)
      params[param].presence
    end

    def empty?(params)
      params[param].blank?
    end

    def __render__(value)
      raise NoMethodError
    end
  end
end