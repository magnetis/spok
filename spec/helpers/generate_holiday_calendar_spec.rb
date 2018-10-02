require 'spec_helper'
require 'tempfile'
require_relative '../../helpers/generate_holiday_calendar'
require_relative '../../helpers/holiday_fetcher'

describe GenerateHolidayCalendar do
  subject { described_class.new(holiday_fetcher: holiday_fetcher) }

  let(:file) { Tempfile.new }

  context 'integration test', vcr: { cassette_name: 'PL_2000' } do
    let (:holiday_fetcher) { HolidayFetcher.new }
    let(:country_code) { 'PL' }

    it 'return data' do
      subject.generate(file: file, country_code: country_code, years: [2000])

      file.rewind
      expect(File.read(file.path)).to start_with(<<~YAML)
        ---
        PL:
        - 2000-01-01
      YAML
    end
  end

  context 'unit test' do
    let(:country_code) { 'PL' }

    context 'for single year' do
      let(:holiday_fetcher) do
        double.tap do |fetcher|
          allow(fetcher).to receive(:fetch).with(country_code, 2018).and_return(
            [HolidayFetcher::Holiday.new(Date.new(2018, 5, 1))]
          )
        end
      end
      it 'return data' do
        subject.generate(file: file, country_code: country_code, years: [2018])

        file.rewind
        expect(File.read(file.path)).to eq(<<~YAML)
          ---
          PL:
          - 2018-05-01
        YAML
      end
    end
    context 'for range of years' do
      let(:holiday_fetcher) do
        double.tap do |fetcher|
          allow(fetcher).to receive(:fetch).with(country_code, 2018).and_return(
            [HolidayFetcher::Holiday.new(Date.new(2018, 5, 1))]
          )
          allow(fetcher).to receive(:fetch).with(country_code, 2017).and_return(
            [HolidayFetcher::Holiday.new(Date.new(2017, 5, 1))]
          )
          allow(fetcher).to receive(:fetch).with(country_code, 2016).and_return(
            [HolidayFetcher::Holiday.new(Date.new(2016, 5, 1))]
          )
        end
      end

      it 'return data' do
        subject.generate(file: file, country_code: country_code, years: (2016..2018))

        file.rewind
        expect(File.read(file.path)).to eq(<<~YAML)
          ---
          PL:
          - 2016-05-01
          - 2017-05-01
          - 2018-05-01
        YAML
      end
    end
  end

end