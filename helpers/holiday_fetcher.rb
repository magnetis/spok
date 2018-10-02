class HolidayFetcher
  class Holiday
    def initialize(date)
      @date = date
    end

    def encode_with(coder)
      coder.tag = nil
      coder.scalar = date.to_s
    end

    private

    attr_reader :date
  end

  def fetch(country_code)
    uri = URI('https://holidayapi.pl/v1/holidays')
    params = { country: country_code, year: 2000 }
    uri.query = URI.encode_www_form(params)

    res = Net::HTTP.get_response(uri)

    if res.is_a?(Net::HTTPSuccess)
      JSON.parse(res.body)['holidays'].keys.map { |date| Holiday.new(date) }
    end
  end
end