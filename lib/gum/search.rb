module Gum
  class Search
    extend Filters

    class_attribute :type
    class_attribute :scope
    class_attribute :fields
    class_attribute :filters
    class_attribute :orders
    class_attribute :query_param

    def self.inherited(klass)
      klass.fields = Set.new
      klass.filters = []
      klass.orders = []
    end

    # @param [Chewy::Type] type
    def self.use(type)
      raise ArgumentError, 'type must be a Chewy::Type' unless type < Chewy::Type
      self.type = type
    end

    def self.scope(&block)
      self.scope = block
    end

    def self.searchable(*attrs)
      self.fields += attrs.flatten
    end

    def self.query(attr)
      self.query_param = attr
    end

    def self.order_by(*args)
      Factory.build(Gum::OrderBy, args) do |order|
        orders.push order
      end
    end

    def initialize(params)
      @params = params
      @q = params[query_param]
    end

    def to_query
      type.query(query).filter(compile_filters).order(compile_orders)
    end

    def search
      to_query.load(scope: scope)
    rescue Elasticsearch::Transport::Transport::Errors::BadRequest => e
      @error = e.message.match(/QueryParsingException\[([^;]+)\]/).try(:[], 1)
      type.none
    end

    private

    def compile_filters
      filters.map do |filter|
        filter.render(@params)
      end.compact
    end

    def compile_orders
      orders.map do |order|
        order.render(@params)
      end.compact
    end

    def query
      return {} unless @q.present?
      {
        query_string: {
          fields: fields.to_a,
          query: @q,
          default_operator: 'and'
        }
      }
    end
  end
end
