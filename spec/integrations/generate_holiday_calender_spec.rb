require 'spec_helper'
require 'tempfile'
require_relative '../../helpers/generate_holiday_calendar'
require_relative '../../helpers/holiday_fetcher'

describe GenerateHolidayCalendar do
  subject { described_class.new(holiday_fetcher: holiday_fetcher, exporter: exporter) }

  let(:file) { Tempfile.new }

  context 'integration test', vcr: { cassette_name: 'PL_2000' } do
    let (:holiday_fetcher) { HolidayFetcher.new }
    let (:exporter) { YamlExporter.new }
    let(:country_code) { 'PL' }

    it 'return correct data' do
      subject.generate(file: file, country_code: country_code, years: [2000])

      file.rewind
      expect(File.read(file.path)).to start_with(<<~YAML)
        ---
        #{File.basename(file.path, '.yml')}:
        - 2000-01-01
      YAML
    end
  end
end
