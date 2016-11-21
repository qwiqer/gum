require 'spec_helper'
require 'chewy'

class DummyIndex < Chewy::Index
  define_type 'Foo' do
  end
end

describe Gum::Search do
  subject { Class.new(Gum::Search) }

  describe 'settings' do
    let(:type) { DummyIndex::Foo }

    subject do
      index = type
      Class.new(Gum::Search) do
        use index
        scope {}
        searchable %i(a b c)
        searchable %i(d e)
        query :q
        term %i(a b c)
        order_by sort_a: 'a', options: { default: 'asc' }
        order_by sort_b: 'b'
      end
    end
    specify { expect(subject.type).to eql type  }
    specify { expect(subject.scope).to be_a Proc  }
    specify { expect(subject.fields).to match_array %i(a b c d e) }
    specify { expect(subject.query_param).to eql :q  }

    specify { expect { subject.new(q: '1', a: 1).search }.not_to raise_error }

    it 'ignores Elasticsearch::Transport::Transport::Errors::BadRequest' do
      allow_any_instance_of(Chewy::Query)
        .to receive(:load).and_raise(Elasticsearch::Transport::Transport::Errors::BadRequest)
      expect(subject.new(q: '1', a: 1).search.to_a).to eql []
    end
  end
end
