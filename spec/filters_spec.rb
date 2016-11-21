require 'spec_helper'

describe Gum::Filters do
  describe '.define_filter' do
    Gum::Filters.define_filter :foo do
      def __render__(value)
        { param => value }
      end
    end

    class DummySearch < Gum::Search
      foo :a
    end

    specify { expect(DummySearch.filters.first).to be_a Gum::Filter }
    specify { expect(DummySearch.filters.first.param).to eql :a }
    specify { expect(DummySearch.filters.first.field).to eql :a }
  end
end
