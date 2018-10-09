require 'spec_helper'
require 'tempfile'
require_relative '../../helpers/holiday_calendar_generator'

describe HolidayCalendarGenerator do
  subject { described_class.new(holiday_fetcher: holiday_fetcher, exporter: exporter) }

  let(:file) { Tempfile.new }
  let(:country_code) { 'PL' }
  let(:holiday_2018_05_01) { HolidayFetcher::Holiday.new(Date.new(2018, 5, 1)) }
  let(:holiday_2017_05_01) { HolidayFetcher::Holiday.new(Date.new(2017, 5, 1)) }
  let(:holiday_2016_05_01) { HolidayFetcher::Holiday.new(Date.new(2016, 5, 1)) }

  let(:exporter) do
    double.tap do |exporter|
      allow(exporter).to receive(:export).with(file, any_args)
    end
  end

  context 'for single year' do
    let(:holiday_fetcher) do
      double.tap do |fetcher|
        allow(fetcher).to receive(:fetch).with(country_code, 2018).and_return(
          [holiday_2018_05_01]
        )
      end
    end

    it 'return data' do
      expect(exporter).to receive(:export).with(file, [holiday_2018_05_01])

      subject.generate(file: file, country_code: country_code, years: [2018])
    end
  end

  context 'for range of years' do
    let(:holiday_fetcher) do
      double.tap do |fetcher|
        allow(fetcher).to receive(:fetch).with(country_code, 2018).and_return(
          [holiday_2018_05_01]
        )
        allow(fetcher).to receive(:fetch).with(country_code, 2017).and_return(
          [holiday_2017_05_01]
        )
        allow(fetcher).to receive(:fetch).with(country_code, 2016).and_return(
          [holiday_2016_05_01]
        )
      end
    end

    it 'return data' do
      expect(exporter).to receive(:export).with(file, [holiday_2016_05_01, holiday_2017_05_01, holiday_2018_05_01])

      subject.generate(file: file, country_code: country_code, years: (2016..2018))
    end
  end
end
