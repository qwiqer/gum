module Gum
  class Factory
    def self.build(type, args)
      mapping = args_to_mapping(args)
      options = mapping.delete(:options)
      mapping.each do |param, field|
        yield new(type, param, field, options)
      end
    end

    def self.args_to_mapping(args)
      args.inject({}) do |mapping, arg|
        mapping.update normalize_mapping(arg)
      end
    end

    def self.normalize_mapping(mapping)
      case mapping
        when Hash
          mapping
        when Array
          mapping.zip(mapping).to_h
        else
          { mapping => mapping }
      end
    end

    def self.new(type, param, field, options)
      filter = type.is_a?(Class) ? type : Filters.const_get(type.to_s.camelize, false)
      filter.new param, field, options
    end
  end
end