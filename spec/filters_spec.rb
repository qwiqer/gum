require 'spec_helper'

describe Gum::Filters do
  describe '.range' do
    let(:params) { { attr_from: 1, attr_to: 2 } }
    subject { described_class.range(:attr) }

    specify do
      expect(subject.call(params)).to match(range: { attr: { gte: 1, lte: 2 } })
    end

    context 'with boost option' do
      subject { described_class.range(:attr, boost: 2) }

      specify do
        expect(subject.call(params)).to match(range: { attr: { gte: 1, lte: 2, boost: 2.0 } })
      end
    end
  end

  describe '.term' do
    let(:params) { { attr: 1 } }
    subject { described_class.term(:attr) }

    specify do
      expect(subject.call(params)).to match(term: { attr: 1 })
    end

    context 'with boost option' do
      subject { described_class.term(:attr, boost: 2.0) }

      specify do
        expect(subject.call(params)).to match(term: { attr: { value: 1, boost: 2.0 } })
      end
    end
  end

  describe '.terms' do
    context 'when array' do
      let(:params) { { attr: [1] } }
      subject { described_class.terms(:attr) }

      specify do
        expect(subject.call(params)).to match(terms: { attr: [1] })
      end
    end

    context 'when string' do
      let(:params) { { attr: '1,2' } }
      subject { described_class.terms(:attr) }

      specify do
        expect(subject.call(params)).to match(terms: { attr: %w(1 2) })
      end
    end
  end

  describe '.exists' do
    context 'when true' do
      let(:params) { { attr: 'true' } }
      subject { described_class.exists(:attr) }

      specify do
        expect(subject.call(params)).to match(exists: { field: :attr })
      end
    end

    context 'when false' do
      let(:params) { { attr: 'false' } }
      subject { described_class.exists(:attr) }

      specify do
        expect(subject.call(params)).to match(bool: { must_not: { exists: { field: :attr } } })
      end
    end
  end

  describe '.prefix' do
    let(:params) { { attr: 'val' } }
    subject { described_class.prefix(:attr) }

    specify do
      expect(subject.call(params)).to match(prefix: { attr: 'val' })
    end
  end

  describe '.wildcard' do
    let(:params) { { attr: 'val*e' } }
    subject { described_class.wildcard(:attr) }

    specify do
      expect(subject.call(params)).to match(wildcard: { attr: 'val*e' })
    end
  end

  describe '.regexp' do
    let(:params) { { attr: 'v.lu+' } }
    subject { described_class.regexp(:attr) }

    specify do
      expect(subject.call(params)).to match(regexp: { attr: 'v.lu+' })
    end
  end

  describe '.fuzzy' do
    let(:params) { { attr: '100_5' } }
    subject { described_class.fuzzy(:attr) }

    specify do
      expect(subject.call(params)).to match(fuzzy: { attr: { value: '100', fuzziness: '5' } })
    end

    context 'without option and default fuzziness' do
      let(:params) { { attr: '100' } }
      subject { described_class.fuzzy(:attr, fuzziness: '2') }

      specify do
        expect(subject.call(params)).to match(fuzzy: { attr: { value: '100', fuzziness: '2' } })
      end
    end
  end
end
