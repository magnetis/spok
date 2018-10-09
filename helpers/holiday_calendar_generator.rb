require_relative 'holiday_fetcher'
require_relative 'yaml_exporter'

class HolidayCalendarGenerator
  def initialize(holiday_fetcher:, exporter:)
    @holiday_fetcher = holiday_fetcher
    @exporter = exporter
  end

  def self.build
    new(holiday_fetcher: HolidayFetcher.new, exporter: YamlExporter.new)
  end

  def generate(file:, country_code:, years:)
    holidays = years.flat_map(&fetch_holidays(country_code))
    exporter.export(file, holidays)
  end

  private

  attr_reader :holiday_fetcher, :exporter

  def fetch_holidays(country_code)
    lambda do |year|
      holiday_fetcher.fetch(country_code, year)
    end
  end
end
