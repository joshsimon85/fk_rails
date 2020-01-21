require_relative 'middleware/logging'
require_relative 'middleware/status_check'
require_relative 'middleware/json_parsing'
require_relative 'middleware/cache'
#require_relative 'storage/memcached'
require_relative 'storage/redis'

module ElevationApi

  class Error < StandardError; end
  class RequestFailure < Error; end
  class ConfiguartionError < Error; end

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

    def fetch_elevation
      resp = connection.get url do |req|
        req.params = {
          points: "(#{lat},#{long})",
          key: ENV['ELEVATION_SECRET_KEY']
        }
      end

      resp.body['elevations'][0]['elevation']
    end

    def connection
      @connection || Faraday::Connection.new do |conn|
        conn.response :json, :content_type => /\bjson$/

        conn.use Middleware::StatusCheck
        conn.use Middleware::JSONParsing
        conn.use Middleware::Logging, Rails.logger
        conn.use Middleware::Cache, Storage::Redis.new
        conn.adapter Faraday.default_adapter
      end
    end
  end
end
