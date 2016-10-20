require 'spec_helper'

describe Gum::Search do
  def compile(attr, params)
    described_class.filters[attr].call(params)
  end

  describe '.range' do
    let(:params) { { attr_from: 1, attr_to: 2 } }

    before do
      described_class.range(:attr)
    end

    specify do
      expect(compile(:attr, params)).to match(range: { attr: { gte: 1, lte: 2 } })
    end
  end

  describe '.term' do
    let(:params) { { attr: 1 } }

    before do
      described_class.term(:attr)
    end

    specify do
      expect(compile(:attr, params)).to match(term: { attr: 1 })
    end
  end

  describe '.terms' do
    context 'when array' do
      let(:params) { { attr: [1] } }
      before do
        described_class.terms(:attr)
      end

      specify do
        expect(compile(:attr, params)).to match(terms: { attr: [1] })
      end
    end

    context 'when string' do
      let(:params) { { attr: '1,2' } }
      before do
        described_class.terms(:attr)
      end

      specify do
        expect(compile(:attr, params)).to match(terms: { attr: %w(1 2) })
      end
    end
  end

  describe '.exists' do
    context 'when true' do
      let(:params) { { attr: 'true' } }
      before do
        described_class.exists(:attr)
      end

      specify do
        expect(compile(:attr, params)).to match(exists: { field: :attr })
      end
    end

    context 'when false' do
      let(:params) { { attr: 'false' } }
      before do
        described_class.exists(:attr)
      end

      specify do
        expect(compile(:attr, params)).to match(bool: { must_not: { exists: { field: :attr } } })
      end
    end
  end

  describe '.prefix' do
    let(:params) { { attr: 'val' } }
    before do
      described_class.prefix(:attr)
    end

    specify do
      expect(compile(:attr, params)).to match(prefix: { attr: 'val' })
    end
  end

  describe '.wildcard' do
    let(:params) { { attr: 'val*e' } }
    before do
      described_class.wildcard(:attr)
    end

    specify do
      expect(compile(:attr, params)).to match(wildcard: { attr: 'val*e' })
    end
  end

  describe '.regexp' do
    let(:params) { { attr: 'v.lu+' } }
    before do
      described_class.regexp(:attr)
    end

    specify do
      expect(compile(:attr, params)).to match(regexp: { attr: 'v.lu+' })
    end
  end

  describe '.fuzzy' do
    let(:params) { { attr: '100' } }
    before do
      described_class.fuzzy(:attr, boost: 2.0, fuzziness: '5')
    end

    specify do
      expect(compile(:attr, params)).to match(fuzzy: { attr: { value: '100', fuzziness: '5', boost: 2.0 } })
    end
  end
end
