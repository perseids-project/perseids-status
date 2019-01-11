module PerseidsStatus
  class Configuration
    include Enumerable

    def initialize(config)
      @config = config
    end

    def each
      config.each do |test, pages|
        pages.each do |name, bundle|
          yield test, name, Request.new(bundle)
        end
      end
    end

    class Request
      attr_reader :url, :compare

      def initialize(args)
        @compare = :diff

        if args.is_a?(Hash)
          @url = args[:url]
          @compare = args[:compare] || @compare
        else
          @url = args
        end
      end

      def diff?
        compare == :diff
      end

      def wc?
        compare == :wc
      end
    end

    private

    attr_reader :config
  end
end
