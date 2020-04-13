require 'active_support'
require 'active_support/core_ext'
require 'spok'

class Spok
  # Internal: Various methods useful for checking for restdays and workdays.
  # All methods are module methods and should be called on the Spok::Workday
  # module.
  module Workday
    # Internal: Hash containing all weekdays.
    WEEKDAYS = {
      sunday: 0,
      monday: 1,
      tuesday: 2,
      wednesday: 3,
      thrusday: 4,
      friday: 5,
      saturday: 6
    }.freeze

    # Internal: Checks if a given day is a restday.
    #
    # date     - The Date to be checked.
    # calendar - Symbol informing in which calendar the date will be checked
    #            (default: :brazil).
    #
    # Examples
    #
    #   Spok::Workday.restday?(Date.new(2012, 8, 6))
    #   # => false
    #
    # Returns a boolean.
    def self.restday?(date, calendar: Spok.default_calendar)
      self.weekend?(date) || self.holiday?(date, calendar: calendar)
    end

    # Internal: Checks if a given day is a workday.
    #
    # date     - The Date to be checked.
    # calendar - Symbol informing in which calendar the date will be checked
    #            (default: :brazil).
    #
    # Examples
    #
    #   Spok::Workday.workday?(Date.new(2012, 8, 6))
    #   # => true
    #
    # Returns a boolean.
    def self.workday?(date, calendar: Spok.default_calendar)
      !restday?(date, calendar: calendar)
    end

    # Internal: Checks if a given Date is on a weekend.
    #
    # date - The Date to be checked.
    #
    # Examples
    #
    #   Spok::Workday.weekend?(Date.new(2012, 8, 6))
    #   # => false
    #
    # Returns a boolean.
    def self.weekend?(date)
      weekday = date.wday

      [WEEKDAYS[:saturday], WEEKDAYS[:sunday]].include? weekday
    end

    # Internal: Checks if a given Date is on a holiday.
    #
    # date     - The Date to be checked.
    # calendar - Symbol informing in which calendar the date will be checked
    #            (default: :brazil).
    #
    # Examples
    #
    #   Spok::Workday.holiday?(Date.new(2012, 5, 1))
    #   # => true
    #
    # Returns a boolean.
    def self.holiday?(date, calendar: Spok.default_calendar)
      dates = Spok::Calendars.get(calendar)
      dates.include?(date.to_date)
    end

    # Internal: Returns the last workday until the informed date.
    # It returns the informed date in case it is a workday.
    #
    # date     - End Date to check for workdays.
    # calendar - Symbol informing in which calendar to check for workdays
    #            (default: :brazil).
    #
    # Examples
    #   Spok::Workday.last_workday(Date.new(2012, 10, 21))
    #   # => #<Date: 2012-10-19 ((2456220j,0s,0n),+0s,2299161j)>
    def self.last_workday(date, calendar: Spok.default_calendar)
      return date if workday?(date, calendar: calendar)

      last_workday((date - 1.day), calendar: calendar)
    end

    # Internal: Returns the next workday starting from the informed date.
    # It returns the informed date in case it is a workday.
    #
    # date     - Start Date to check for workdays.
    # calendar - Symbol informing in which calendar to check for workdays
    #            (default: :brazil).
    #
    # Examples
    #   Spok::Workday.next_workday(Date.new(2012, 10, 21))
    #   # => #<Date: 2012-10-19 ((2456220j,0s,0n),+0s,2299161j)>
    def self.next_workday(date, calendar: Spok.default_calendar)
      return date if workday?(date, calendar: calendar)

      next_workday((date + 1.day), calendar: calendar)
    end

    class << self
      extend Gem::Deprecate

      deprecate :restday?, 'Spok.restday?', 2020, 12
      deprecate :workday?, 'Spok.workday?', 2020, 12
      deprecate :weekend?, 'Spok.weekend?', 2020, 12
      deprecate :holiday?, 'Spok.holiday?', 2020, 12
      deprecate :last_workday, 'Spok.last_workday', 2020, 12
      deprecate :next_workday, 'Spok.next_workday', 2020, 12
    end
  end
end
