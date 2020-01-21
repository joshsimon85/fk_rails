module DarkSkiesApi
  class Client
    attr_reader :url

    BASE_URL = "https://api.darksky.net/forecast/#{ENV['DARK_SKIES_SECRET_KEY']}/"

    def initialize(lat, long)
      set_url(lat, long)
    end

    def set_url(lat, long)
      @url = "#{BASE_URL}#{lat},#{long}"
    end

    def api_connection
      Faraday.new(
        url: url,
        params: {
          exclude: 'minutely,hourly,daily,alerts,flags',
          lan: 'en',
          units: 'us'
        }
      )
    end

    def fetch_weather
      resp = api_connection.get
      JSON.parse(resp.body)
    end
  end
end
