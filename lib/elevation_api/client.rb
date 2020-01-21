module ElevationApi
  class Client
    attr_reader :url, :lat, :long

    BASE_URL = "https://elevation-api.io/api/elevation"

    def initialize(lat, long)
      @lat = lat
      @long = long
      set_url
    end

    def set_url
      @url = "#{BASE_URL}"
    end

    def api_connection
      Faraday.new(
        url: url,
        params: {
          points: "(#{lat},#{long})",
          key: ENV['ELEVATION_SECRET_KEY']
        }
      )
    end

    def fetch_elevation
      resp = api_connection.get
      data = JSON.parse(resp.body)
      data['elevations'][0]['elevation']
    end
  end
end
