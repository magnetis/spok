require_relative 'generate_holiday_calendar'
require_relative 'holiday_fetcher'

desc 'Generate holiday calender for given country'
task :generate_calender, [:start_year, :end_year] do |t, args|
  years = (args[:start_year]..args[:end_year])

  Country = Struct.new(:code, :name)
  countries = [
    Country.new('pl', 'poland'),
    Country.new('de', 'germany'),
    Country.new('us', 'united_states'),
  ]

  countries.each do |country|
    country_code = country.code
    country_name = country.name
    File.open(File.expand_path("lib/spok/config/#{country_name}.yml"), "w") do |file|
      GenerateHolidayCalendar.new(holiday_fetcher: HolidayFetcher.new).generate(file: file, country_code: country_code, years: years)
    end
    puts 'File generated'
  end
  puts 'Files generated'
end