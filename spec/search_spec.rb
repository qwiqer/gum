require 'spec_helper'

describe Gum::Search do
  subject { Class.new(Gum::Search) }

  describe 'filters' do
    def compile(attr, params)
      subject.filters.find { |filter| filter.param == attr }.render(params)
    end

    describe '.range' do
      let(:params) { { attr_from: 1, attr_to: 2 } }

      before do
        subject.range(:attr)
      end

      specify do
        expect(compile(:attr, params)).to match(range: { attr: { gte: 1, lte: 2 } })
      end
    end

    describe '.term' do
      let(:params) { { attr: 1 } }

      context 'with no options' do
        before do
          subject.term(:attr)
        end

        specify do
          expect(compile(:attr, params)).to match(term: { attr: 1 })
        end
      end

      context 'with boost' do
        before do
          subject.term(:attr, options: { boost: 2.0 })
        end

        specify do
          expect(compile(:attr, params)).to match(term: { attr: { value: 1, boost: 2.0 } })
        end
      end
    end

    describe '.terms' do
      context 'when array' do
        let(:params) { { attr: [1] } }
        before do
          subject.terms(:attr)
        end

        specify do
          expect(compile(:attr, params)).to match(terms: { attr: [1] })
        end
      end
    end

    describe '.exists' do
      context 'when true' do
        let(:params) { { attr: 'true' } }
        before do
          subject.exists(:attr)
        end

        specify do
          expect(compile(:attr, params)).to match(exists: { field: :attr })
        end
      end

      context 'when false' do
        let(:params) { { attr: 'false' } }
        before do
          subject.exists(:attr)
        end

        specify do
          expect(compile(:attr, params)).to match(bool: { must_not: { exists: { field: :attr } } })
        end
      end
    end

    describe '.prefix' do
      let(:params) { { attr: 'val' } }

      context 'with no options' do
        before do
          subject.prefix(:attr)
        end

        specify do
          expect(compile(:attr, params)).to match(prefix: { attr: 'val' })
        end
      end

      context 'with boost' do
        before do
          subject.prefix(:attr, options: { boost: 2.0 })
        end

        specify do
          expect(compile(:attr, params)).to match(prefix: { attr: { value: 'val', boost: 2.0 } })
        end
      end
    end

    describe '.wildcard' do
      let(:params) { { attr: 'val*e' } }

      context 'with no options' do
        before do
          subject.wildcard(:attr)
        end

        specify do
          expect(compile(:attr, params)).to match(wildcard: { attr: 'val*e' })
        end
      end

      context 'with boost' do
        before do
          subject.wildcard(:attr, options: { boost: 2.0 })
        end

        specify do
          expect(compile(:attr, params)).to match(wildcard: { attr: { value: 'val*e', boost: 2.0 } })
        end
      end
    end

    describe '.regexp' do
      let(:params) { { attr: 'v.lu+' } }
      before do
        subject.regexp(:attr)
      end

      specify do
        expect(compile(:attr, params)).to match(regexp: { attr: { value: 'v.lu+' } })
      end
    end

    describe '.fuzzy' do
      let(:params) { { attr: '100' } }
      before do
        subject.fuzzy(:attr, options: { boost: 2.0, fuzziness: '5' })
      end

      specify do
        expect(compile(:attr, params)).to match(fuzzy: { attr: { value: '100', fuzziness: '5', boost: 2.0 } })
      end
    end

    describe '.geo' do
      context 'type: :bbox' do
        let(:params) { { bounds: '40,-70,41,-72' } }
        before do
          subject.geo(bounds: :location, options: { type: :bbox, pattern: 'left,top,right,bottom' })
        end

        specify do
          expect(compile(:bounds, params))
            .to match(geo_bounding_box: { location: { top: -70.0, left: 40.0, bottom: -72.0, right: 41.0 } })
        end
      end

      context 'type: :distance' do
        let(:params) { { location: '40,-70', location_distance: '1km' } }
        before do
          subject.geo(:location, options: { type: :distance })
        end

        specify do
          expect(compile(:location, params))
            .to match(geo_distance: { distance: '1km', location: '40,-70' })
        end
      end

      context 'type: :range' do
        let(:params) { { location: '40,-70', location_from: '1km', location_to: '2km' } }
        before do
          subject.geo(:location, options: { type: :range })
        end

        specify do
          expect(compile(:location, params))
            .to match(geo_distance_range: { from: '1km', to: '2km', location: '40,-70' })
        end
      end
    end
  end
end
