require 'gum/factory'
require 'gum/filter'
require 'gum/filters/term'
require 'gum/filters/terms'
require 'gum/filters/exists'
require 'gum/filters/prefix'
require 'gum/filters/wildcard'
require 'gum/filters/regexp'
require 'gum/filters/fuzzy'
require 'gum/filters/range'
require 'gum/filters/geo'
require 'gum/filters/geo/bbox'
require 'gum/filters/geo/distance'
require 'gum/filters/geo/range'
require 'gum/order'

module Gum
  module Filters
    def self.register(method, klass = nil)
      define_method method do |*args|
        Factory.build(klass || method, args) do |filter|
          filters.push filter
        end
      end
    end

    def self.define_filter(method, &block)
      register method, Class.new(Gum::Filter, &block)
    end

    %i(term terms prefix wildcard regexp fuzzy exists geo range).each do |method|
      register method
    end
  end
end
