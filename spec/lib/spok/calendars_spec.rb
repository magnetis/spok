require 'spec_helper'
require 'spok'

describe Spok::Calendars do
  it 'loads a new calendar' do
    Spok::Calendars.add(:custom_calendar, File.expand_path('../../fixtures/custom-calendar.yml', __dir__))

    expect(Spok::Workday.restday?(Date.new(2019, 01, 25), calendar: :custom_calendar)).to eq(true)
    expect(Spok::Workday.workday?(Date.new(2019, 01, 25), calendar: :custom_calendar)).to eq(false)
  end
end
