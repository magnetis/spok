require_relative 'holiday_calendar_generator'
require_relative 'holiday_fetcher'

desc 'Generate holiday calender for given country'
task :generate_calender, [:start_year, :end_year] do |t, args|
  Country = Struct.new(:code, :name)

  years = (args[:start_year]..args[:end_year])
  countries = YAML.load_file('helpers/country_list.yml')

  countries.each do |country_code, country_name|
    File.open(File.expand_path("lib/spok/config/#{country_name}.yml"), "w") do |file|
      HolidayCalendarGenerator.build.generate(file: file, country_code: country_code, years: years)
    end
    puts 'File generated'
  end
  puts 'Files generated'
end
