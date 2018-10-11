require 'spec_helper'
require_relative '../../helpers/holiday_fetcher'

RSpec::Matchers.define :be_holiday_array_of_size do |expected|
  match do |actual|
    expect(actual.count).to eq(expected)
    expect(actual).to all(be_an(HolidayFetcher::Holiday))
  end
end

RSpec::Matchers.define :include_holiday do |expected|
  match do |actual|
    expect(actual).to include(HolidayFetcher::Holiday.new(expected))
  end
end

RSpec.shared_examples :includes_holidays do |count, holidays|
  it { is_expected.to be_holiday_array_of_size(count) }
  holidays.each do |holiday|
    it { is_expected.to include_holiday(holiday) }
  end
end

describe HolidayFetcher do
  let(:fetcher) { described_class.new }

  describe '#fetch' do
    subject { fetcher.fetch(country_code, year) }

    context 'with Poland 2000', vcr: { cassette_name: 'PL_2000' } do
      let(:year) { 2000 }
      let(:country_code) { 'PL' }

      it_behaves_like :includes_holidays, 13, ['2000-01-01']
    end

    context 'with Great Britain 2001', vcr: { cassette_name: 'GB_2001' } do
      let(:year) { 2001 }
      let(:country_code) { 'GB' }

      it_behaves_like :includes_holidays, 8, ['2001-01-01']
    end
  end
end
