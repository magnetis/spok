class HolidayFetcher
  class Holiday
    def initialize(date)
      @date = date
    end

    def encode_with(coder)
      coder.tag = nil
      coder.scalar = date.to_s
    end

    def ==(other)
      other.is_a?(Holiday) && other.date == date
    end

    protected

    attr_reader :date
  end

  def fetch(country_code, year)
    uri = URI('https://holidayapi.pl/v1/holidays')
    params = { country: country_code, year: year }
    uri.query = URI.encode_www_form(params)

    res = Net::HTTP.get_response(uri)

    if res.is_a?(Net::HTTPSuccess)
      JSON.parse(res.body)['holidays'].keys.map { |date| Holiday.new(date) }
    end
  end
end