module ElevationApi
  module Storage
    class Redis
      def initialize(redis=::Redis.new)
        @redis = redis
      end

      def write(key, value)
        @redis.set(key, Marshal.dump(value))
      end

      def read(key)
        value = @redis.get(key)
        Marshal.load(value) if value
      end

      def flush
        @redis.flushall
      end
    end
  end
end
