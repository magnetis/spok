require 'spec_helper'
require 'tempfile'

describe HolidayCalendarGenerator do
  subject { described_class.build }

  let(:file) { Tempfile.new }
  let(:country_code) { 'PL' }

  it 'return correct data', vcr: { cassette_name: 'PL_2000' } do
    subject.generate(file: file, country_code: country_code, years: [2000])

    file.rewind
    expect(File.read(file.path)).to start_with(<<~YAML)
      ---
      #{File.basename(file.path, '.yml')}:
      - 2000-01-01
    YAML
  end
end
