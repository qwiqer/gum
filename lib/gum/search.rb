module Gum
  class Search
    class_attribute :type
    class_attribute :scope
    class_attribute :fields
    class_attribute :filters
    class_attribute :orders
    class_attribute :query_param

    def self.inherited(base)
      self.fields = Set.new
      self.filters = {}
      self.orders = {}
    end

    # @param [Chewy::Type] type
    def self.use(type)
      self.type = type
    end

    def self.scope(&block)
      self.scope = block
    end

    def self.searchable(*attrs)
      self.fields += attrs
    end

    def self.query(attr)
      self.query_param = attr
    end

    Filters.singleton_methods.each do |method|
      define_singleton_method method do |*attrs|
        options = attrs.extract_options!
        attrs.each do |attr|
          filters[attr] = Filters.public_send(method, attr, options)
        end
      end
    end

    def self.order_by(*attrs)
      attrs.each do |attr|
        orders[attr] =
          lambda do |params|
            Coerce.split(attr, params) do |field, direction|
              { field => direction }
            end
          end
      end
    end

    def initialize(params)
      @params = params
      @sort_params = @params[:sort].split(',') if @params[:sort]
      @q = params[query_param]
    end

    def compile_filters
      filters.map do |_, proc|
        proc.call(@params)
      end.compact
    end

    def compile_orders
      if @sort_params
        self.orders = {}
        @sort_params.each do |attr|
          self.class.order_by(attr)
        end
      end
      orders.map do |attr, proc|
        proc.call(attr)
      end.compact
    end

    def search
      type.query(query).filter(compile_filters).order(compile_orders).load(scope: scope)
    rescue Elasticsearch::Transport::Transport::Errors::BadRequest => e
      @error = e.message.match(/QueryParsingException\[([^;]+)\]/).try(:[], 1)
      type.none
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
