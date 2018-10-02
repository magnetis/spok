require 'spec_helper'
require 'spok'

describe Spok do
  let(:sunday) { Date.new(2012, 1, 1) }
  let(:monday) { Date.new(2012, 1, 2) }
  let(:tuesday) { Date.new(2012, 1, 3) }

  subject(:spok) { described_class.new(sunday, tuesday) }

  describe '.parse' do
    it { expect(described_class.parse('20120101-20120103')).to eq(spok) }

    context 'when the input string is wrong' do
      it { expect(described_class.parse('20120101')).to be_nil }
      it { expect(described_class.parse(nil)).to be_nil }
      it { expect(described_class.parse('')).to be_nil }
    end
  end

  describe '#initialize' do
    it 'does not raise error when start date is before or equals to the end date' do
      expect { subject }.not_to raise_error
      expect { described_class.new(sunday, sunday) }.not_to raise_error
    end

    it 'raises exception when the start date is nil' do
      expect { described_class.new(nil, sunday) }.to raise_error(ArgumentError)
    end

    it 'raises exception when the end date is nil' do
      expect { described_class.new(tuesday, nil) }.to raise_error(ArgumentError)
    end

    it 'raises exception when the start date is greater than the end date' do
      expect { described_class.new(tuesday, sunday) }.to raise_error(ArgumentError)
    end
  end

  describe '#date_as_integer' do
    it 'represents the start date as integer' do
      expect(subject.start_date_as_integer).to eq(20120101)
    end

    it 'represents the end date as integer' do
      expect(subject.end_date_as_integer).to eq(20120103)
    end
  end

  describe '#date_as_string' do
    it 'represents the start date as string' do
      expect(subject.start_date_as_string).to eq('20120101')
    end

    it 'represents the end date as string' do
      expect(subject.end_date_as_string).to eq('20120103')
    end
  end

  describe '#to_s' do
    it 'successfully converts Spok to String' do
      expect(spok.to_s).to eq('20120101-20120103')
    end
  end

  describe '#workdays' do
    subject(:spok) { described_class.new(sunday, wednesday) }

    let(:sunday) { Date.new(2013, 7, 7) }
    let(:monday) { Date.new(2013, 7, 8) }
    let(:bovespa_holiday) { Date.new(2013, 7, 9) }
    let(:wednesday) { Date.new(2013, 7, 10) }

    it 'returns all workdays when no calendar is selected' do
      expect(spok.workdays).to eq([monday, bovespa_holiday, wednesday])
    end

    it 'returns only bovespa workdays when bovespa calendar is selected' do
      expect(subject.workdays(:bovespa)).to eq([monday, wednesday])
    end
  end

  describe '#to_calendar' do
    context 'when bovespa is the calendar' do
      subject { described_class.new(sunday, tuesday).to_calendar(:bovespa) }
      context 'and start date on a bovespa holiday' do
        let(:start_date) { Date.new(2013, 7, 8) }
        let(:sunday)      { Date.new(2013, 7, 9) } # bovespa holiday
        let(:tuesday)      { Date.new(2013, 7, 11) }
        it 'returns the last bovespa workday as the start date' do
          expect(subject.start_date).to eq(start_date)
        end
      end

      context 'and end date on a bovespa holiday' do
        let(:sunday)    { Date.new(2013, 7, 7) }
        let(:tuesday)    { Date.new(2013, 7, 9) } # bovespa holiday
        let(:end_date) { Date.new(2013, 7, 8) }
        it 'returns the last bovespa workday as the end date' do
          expect(subject.end_date).to eq(end_date)
        end
      end

      context 'and start and end date on a bovespa holiday' do
        let(:sunday)    { Date.new(2012, 12, 31) } #bovespa holiday
        let(:tuesday)    { Date.new(2013, 1, 1) } # bovespa holiday
        it 'start and end date are going to be the same' do
          expect(subject.start_date).to eq(subject.end_date)
        end
      end
    end

    context 'when brasil is the calendar' do
      subject { described_class.new(sunday, tuesday).to_calendar(:brasil) }

      context 'and the start date is holiday' do
        let(:start_date) { Date.new(2013, 9, 6) }
        let(:sunday)      { Date.new(2013, 9, 7) } # brasil holiday
        let(:tuesday)      { Date.new(2013, 9, 10) }
        it 'returns the last workday as the start date' do
          expect(subject.start_date).to eq(start_date)
        end
      end

      context 'end date on a bovespa holiday' do
        let(:sunday)    { Date.new(2013, 9, 5) }
        let(:tuesday)    { Date.new(2013, 9, 7) } # brasil holiday
        let(:end_date) { Date.new(2013, 9, 6) }
        it 'returns the last bovespa workday as the end date' do
          expect(subject.end_date).to eq(end_date)
        end
      end
    end
  end

  describe '#one_day?' do
    context 'when the start and end date are the same' do
      let(:tuesday)    { sunday }
      it { expect(subject).to be_one_day }
    end

    context 'when the start and end date are different' do
      it { expect(subject).not_to be_one_day }
    end
  end

  describe '#days_count' do
    it 'counts number of days on spok' do
      spok = described_class.new(sunday, tuesday)

      expect(spok.days_count).to eq(2)
    end

    it 'returns 0 when start date is equal to the end date' do
      spok = described_class.new(sunday, sunday)

      expect(spok.days_count).to eq(0)
    end
  end

  describe '#years_count' do
    let(:start_date) { Date.new(2013, 1, 1) }

    it 'calculates integer result' do
      end_date = Date.new(2014, 1, 1)

      expect(described_class.new(start_date, end_date).years_count).to eq(1)
    end

    it 'calculates fraction result' do
      spok = described_class.new(start_date, Date.new(2014, 7, 1))
      greater_spok = described_class.new(start_date, Date.new(2014, 9, 1))

      expect(spok.years_count).to eq(1.5)
      expect(greater_spok.years_count).to eq(1.7)
    end
  end

  describe '#==' do
    let(:spok) { Spok.new(sunday, tuesday) }

    context 'when spoks are equal' do
      let(:other_spok) { Spok.new(sunday, tuesday) }

      it { expect(spok == other_spok).to eq(true) }
    end

    context 'when spoks are not equal' do
      let(:other_spok) { Spok.new(sunday, monday) }

      it { expect(spok == other_spok).to eq(false) }
    end

    context 'when the comparison does respond to start date' do
      let(:other_spok) { double(:other_spok, :end_date => double(:end_date)) }
      it { expect(spok == other_spok).to eq(false) }
    end

    context 'when the comparison does respond to end date' do
      let(:other_spok) { double(:other_spok, :start_date => sunday) }
      it { expect(spok == other_spok).to eq(false) }
    end
  end

  describe '#to_range' do
    subject { Spok.new(sunday, tuesday).to_range }
    it { is_expected.to eq((sunday..tuesday)) }
  end

  describe '#default_calendar' do
    it 'changes default_calendar' do
      default_calendar_was = Spok.default_calendar
      spok = double("spok", :default_calendar => :bovespa)

      expect(default_calendar_was).not_to eq(spok.default_calendar)
      expect(default_calendar_was).to eq(:brasil)
    end
  end
end
