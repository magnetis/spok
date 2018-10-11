require_relative 'holiday_calendar_generator'
require_relative 'holiday_fetcher'

desc 'Generate holiday calenders for given countries'
task :generate_calenders, [:start_year, :end_year] do |t, args|
  Country = Struct.new(:code, :name)

  years = (args[:start_year]..args[:end_year])
  countries = YAML.load_file('helpers/country_list.yml')

  countries.map do |country_code, country_name|
    Thread.new do
      File.open(File.expand_path("lib/spok/config/#{country_name}.yml"), "w") do |file|
        HolidayCalendarGenerator.build.generate(file: file, country_code: country_code, years: years)
      end
      puts "File generated for #{country_name}"
    end
  end.each(&:join)
  puts 'Files generated'
end
