require_relative 'middleware/logging'
require_relative 'middleware/status_check'
require_relative 'middleware/json_parsing'
require_relative 'middleware/cache'
require_relative 'storage/redis'

module DarkSkiesApi

  class Error < StandardError; end
  class RequestFailure < Error; end
  class ConfiguartionError < Error; end

  class Client
    attr_reader :url

    BASE_URL = "https://api.darksky.net/forecast/#{ENV['DARK_SKIES_SECRET_KEY']}/"

    def initialize(lat, long)
      set_url(lat, long)
    end

    def set_url(lat, long)
      @url = "#{BASE_URL}#{lat},#{long}"
    end

    def fetch_weather
      resp = connection.get url do |req|
        req.params = {
          exclude: 'minutely,hourly,daily,alerts,flags',
          lan: 'en',
          units: 'us'
        }
      end

      resp.body
    end

    def connection
      @connection || Faraday::Connection.new do |conn|
        conn.response :json, :content_type => /\bjson$/

        conn.use Middleware::StatusCheck
        conn.use Middleware::JSONParsing
        conn.use Middleware::Logging, Rails.logger
        conn.use Middleware::Cache, Storage::Redis.new(REDIS)
        conn.adapter Faraday.default_adapter
      end
    end
  end
end
