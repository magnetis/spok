require 'spec_helper'
require_relative '../../helpers/holiday_fetcher'

describe HolidayFetcher do
  it 'generate file', vcr: { cassette_name: 'PL_2000' } do
    country_code = 'PL'

    holidays = subject.fetch(country_code)

    expect(holidays.count).to eq(13)
  end
end