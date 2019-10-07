require 'set'
require 'yaml'

class Spok
  # Internal: Module responsible for loading and collecting calendar definitions
  # from YAML files.
  module Calendars
    @@calendars = {}

    # Public: Add a new calendar.
    #
    # name - A String or Symbol with the name of the calendar.
    # path - A String with the full path for the calendar YAML file.
    #
    # Returns nothing.
    def self.add(name, path)
      @@calendars[name.to_s] = load(name, path)
    end

    # Public: Get a calendar.
    #
    # name - A String or Symbol with the name of the calendar.
    #
    # Raises a `KeyError` if the calender does not exists.
    # Returns a `Set`.
    def self.get(name)
      @@calendars.fetch(name.to_s) { raise KeyError, "Calendar not found: #{name}" }
    end

    # Internal: Preloads existing calendars into memory.
    #
    # Returns nothing.
    def self.preload
      Dir[File.expand_path("config/*.yml", __dir__)].each do |path|
        name = File.basename(path, '.yml')
        add(name, path)
      end
    end

    def self.load(name, path)
      dates = YAML.safe_load(File.read(path), [Date])
      Set.new(dates[name.to_s])
    end

    private_class_method :load
  end
end
