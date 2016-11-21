module Gum
  class OrderBy < Filter
    ALLOWED_VALUES = %w(asc desc).freeze

    def __render__(value)
      { field => value }
    end

    def value_from(params)
      value = super.to_s
      ALLOWED_VALUES.include?(value) ? value : options[:default]
    end

    def empty?(params)
      ALLOWED_VALUES.exclude?(params[param].to_s) && options[:default].nil?
    end
  end
end