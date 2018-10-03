require 'json'
require 'yaml'

class YamlExporter
  def export(file, holidays)
    holidays_hash = { File.basename(file.path, '.yml') => holidays }
    file.write(holidays_hash.to_yaml)
  end
end

class GenerateHolidayCalendar
  def initialize(holiday_fetcher:, exporter: YamlExporter.new)
    @holiday_fetcher = holiday_fetcher
    @exporter = exporter
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