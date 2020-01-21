module DarkSkiesApi
  module Middleware
    class Cache < Faraday::Middleware
      attr_reader :storage

      def initialize(app, storage={})
        super(app)
        @storage = storage
      end

      def call(env)
        key = env.url.to_s
        cached_response = storage.read(key)

        if cached_response
          cached_response = Response.new(Marshal.load(cached_response))

          if cached_response.fresh?
            response = Marshal.load(storage.read(key))
            response.env.response_headers["X-Faraday-Cache-Status"] = "true"

            return response
          end
        end

        @app.call(env).on_complete do |response_env|
          data = Marshal.dump(response_env.response)
          storage.write(key, data)
          return response_env.response
        end
      end


      class Response
        attr_reader :http_response

        def initialize(http_response)
          @http_response = http_response
        end

        def response_age
          date = http_response.headers['Date']
          time = Time.httpdate(date) if date
          (Time.now - time).floor if time
        end

        def response_max_age
          cache_control = http_response.headers['cache-control']
          return nil unless cache_control
          match = cache_control.match(/max\-age=(\d+)/)

          match[1].to_i * 15 if match
        end

        def fresh?
          age = response_age
          max_age = response_max_age

          if age && max_age
            age < max_age
          end
        end

        def exist?
          !http_response.nil?
        end

        def env
          http_response.env
        end
      end
    end
  end
end
