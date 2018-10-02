require 'json'
require 'yaml'

class GenerateHolidayCalendar
  def initialize(holiday_fetcher:)
    @holiday_fetcher = holiday_fetcher
  end

  def generate(file:, country_code:, years:)
    holidays = years.flat_map(&fetch_holidays(country_code))
    holidays_hash = { country_code => holidays }
    file.write(holidays_hash.to_yaml)
  end

  private

  attr_reader :holiday_fetcher

  def fetch_holidays(country_code)
    lambda do |year|
      holiday_fetcher.fetch(country_code, year)
    end
  end
end