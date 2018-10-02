require 'spec_helper'
require 'spok/workday'

describe Spok::Workday do
  describe '#workday?' do
    context 'monday' do
      it 'is a workday' do
        expect(described_class.workday?(Date.new(2012, 8, 6))).to eq(true)
      end
    end

    context 'saturday' do
      it 'is not a workday' do
        expect(described_class.workday?(Date.new(2012, 8, 4))).to eq(false)
      end
    end

    context 'sunday' do
      it 'is not a workday' do
        expect(described_class.workday?(Date.new(2012, 8, 5))).to eq(false)
      end
    end

    context 'holidays using brasil calendar' do
      it 'is not a workday' do
        ['2012-06-07', '2012-09-07', '2012-10-12',
         '2012-11-02', '2012-11-15', '2012-12-25'].each do |holiday|
          expect(described_class.workday?(Date.parse(holiday))).to eq(false)
        end
      end
    end

    context 'holidays using bovespa calendar' do
      it 'is not a workday' do
        ['2012-07-09', '2012-11-20', '2012-12-24'].each do |holiday|
          expect(described_class.workday?(Date.parse(holiday), calendar: :bovespa)).to eq(false)
        end
      end
    end

    context 'days using spanish calendar' do
      it 'is not a workday' do
        ['2009-01-06', '2009-04-10', '2009-04-12'].each do |holiday|
          expect(described_class.workday?(Date.parse(holiday), calendar: :spain)).to eq(false)
        end
      end

      it 'is a workday' do
        ['2009-01-07', '2019-01-14', '2020-04-22'].each do |workday|
          expect(described_class.workday?(Date.parse(workday), calendar: :spain)).to eq(true)
        end
      end
    end

    context 'days using dutch calendar' do
      it 'is not a workday' do
        ['2019-06-10', '2019-12-25', '2019-12-26'].each do |holiday|
          expect(described_class.workday?(Date.parse(holiday), calendar: :netherlands)).to eq(false)
        end
      end

      it 'is a workday' do
        ['2010-06-10', '2009-09-11', '2019-12-02'].each do |workday|
          expect(described_class.workday?(Date.parse(workday), calendar: :netherlands)).to eq(true)
        end
      end
    end
  end

  describe '#restday?' do
    context 'Using Date objects' do
      context 'monday' do
        it 'is not a restday' do
          expect(described_class.restday?(Date.new(2012, 8, 6))).to eq(false)
        end
      end

      context 'saturday' do
        it 'is a restday' do
          expect(described_class.restday?(Date.new(2012, 8, 4))).to eq(true)
        end
      end

      context 'sunday' do
        it 'is a restday' do
          expect(described_class.restday?(Date.new(2012, 8, 5))).to eq(true)
        end
      end

      context 'holiday' do
        [
          Date.new(2012, 6, 07),
          Date.new(2012, 9, 07),
          Date.new(2012, 10, 12),
          Date.new(2012, 11, 02),
          Date.new(2012, 11, 15),
          Date.new(2012, 12, 25)
        ].each do |holiday|
          it 'is a restday' do
            expect(described_class.restday?(holiday)).to eq(true)
          end
        end
      end
    end

    context 'using DateTime objects' do
      context 'monday' do
        it 'is not a restday' do
          expect(described_class.restday?(DateTime.new(2012, 8, 6, 12))).to eq(false)
        end
      end

      context 'saturday' do
        it 'is a restday' do
          expect(described_class.restday?(DateTime.new(2012, 8, 4, 12))).to eq(true)
        end
      end

      context 'sunday' do
        it 'is a restday' do
          expect(described_class.restday?(DateTime.new(2012, 8, 5, 13))).to eq(true)
        end
      end

      context 'holiday' do
        [
          DateTime.new(2017, 01, 01, 00),
          DateTime.new(2017, 10, 12, 01),
          DateTime.new(2017, 11, 02, 02),
          DateTime.new(2017, 11, 15, 03),
          DateTime.new(2017, 12, 25, 04)
        ].each do |holiday|
          it 'is a restday' do
            expect(described_class.restday?(holiday)).to eq(true)
          end
        end
      end
    end
  end

  describe '#weekend?' do
    it 'returns true when date is a Saturday' do
      expect(described_class.weekend?(Date.new(2018, 8, 11))).to eq(true)
    end

    it 'returns true when date is a Sunday' do
      expect(described_class.weekend?(Date.new(2018, 8, 12))).to eq(true)
    end

    it 'returns false when date is not a Saturday or Sunday' do
      expect(described_class.weekend?(Date.new(2018, 8, 13))).to eq(false)
      expect(described_class.weekend?(Date.new(2018, 8, 14))).to eq(false)
      expect(described_class.weekend?(Date.new(2018, 8, 15))).to eq(false)
      expect(described_class.weekend?(Date.new(2018, 8, 16))).to eq(false)
      expect(described_class.weekend?(Date.new(2018, 8, 17))).to eq(false)
    end
  end

  describe '#holiday?' do
    it 'returns false when date is not a holiday on the given calendar' do
      expect(described_class.holiday?(Date.new(2018, 05, 02), calendar: :brasil)).to eq(false)
      expect(described_class.holiday?(Date.new(2018, 12, 15), calendar: :bovespa)).to eq(false)
    end

    it 'returns true when date is a holiday on the given calendar' do
      expect(described_class.holiday?(Date.new(2018, 05, 01), calendar: :brasil)).to eq(true)
      expect(described_class.holiday?(Date.new(2018, 12, 25), calendar: :bovespa)).to eq(true)
    end
  end

  describe '#last_workday' do
    context 'when date is 2012-10-25 (Thursday)' do
      it 'returns the same date' do
        expect(described_class.last_workday(Date.new(2012, 10, 25))).to eq(Date.new(2012, 10, 25))
      end
    end

    context 'when date is 2012-10-21 (Sunday)' do
      it 'returns 2012-10-19 (Friday)' do
        expect(described_class.last_workday(Date.new(2012, 10, 21))).to eq(Date.new(2012, 10, 19))
      end
    end

    context 'when date is 2012-10-20 (Saturday)' do
      it 'returns 2012-10-19 (Friday)' do
        expect(described_class.last_workday(Date.new(2012, 10, 20))).to eq(Date.new(2012, 10, 19))
      end
    end

    context 'when bovespa calendar' do
      context 'when date is 2013-01-01 (bovespa holiday)' do
        it 'returns 2012-12-30,  because 2012-12-31 is also a bovespa holiday and 2012-01-30|29 is a weekend' do
          expect(described_class.last_workday(Date.new(2013, 1, 1), calendar: :bovespa)).to eq(Date.new(2012, 12, 28))
        end
      end
    end
  end

  describe '#next_workday' do
    context 'when date is 2012-10-26 (Friday)' do
      it 'returns the same date' do
        expect(described_class.next_workday(Date.new(2012, 10, 26))).to eq(Date.new(2012, 10, 26))
      end
    end

    context 'when date is 2012-10-21 (Sunday)' do
      it 'returns 2012-10-22 (Monday)' do
        expect(described_class.next_workday(Date.new(2012, 10, 21))).to eq(Date.new(2012, 10, 22))
      end
    end

    context 'when date is 2012-10-20 (Saturday)' do
      it 'returns 2012-10-22 (Monday)' do
        expect(described_class.next_workday(Date.new(2012, 10, 20))).to eq(Date.new(2012, 10, 22))
      end
    end

    context 'when bovespa calendar' do
      context 'when date is 2012-12-30 (sunday)' do
        it 'returns 2013-01-02, because 2012, 12, 31 and 2013-01-01 are bovespa holidays' do
          expect(described_class.next_workday(Date.new(2012, 12, 30), calendar: :bovespa)).to eq(Date.new(2013, 1, 2))
        end
      end
    end
  end
end
