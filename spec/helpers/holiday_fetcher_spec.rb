require 'spec_helper'
require_relative '../../helpers/holiday_fetcher'

describe HolidayFetcher do
  let(:fetcher) { described_class.new }

  describe '#fetch' do
    subject { fetcher.fetch(country_code, year) }

    context 'with Poland 2000', vcr: { cassette_name: 'PL_2000'} do
      let(:year) { 2000 }
      let(:country_code) { 'PL' }

      it 'parse data for given year' do
        expect(subject.count).to eq(13)
        expect(subject).to include(HolidayFetcher::Holiday.new('2000-01-01'))
      end
    end

    context 'with Great Britain 2001', vcr: { cassette_name: 'GB_2001' } do
      let(:year) { 2001 }
      let(:country_code) { 'GB' }

      it 'generate file' do
        expect(subject.count).to eq(8)
        expect(subject).to include(HolidayFetcher::Holiday.new('2001-01-01'))
      end
    end
  end
end