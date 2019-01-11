class PerseidsStatus
  class RequestMap
    def self.from_hash(hash = {})
      requests = []

      hash.each do |test, pages|
        pages.each do |name, request|
          args = request.is_a?(Hash) ? request : { url: request }
          args[:test] = test
          args[:name] = name

          requests << Request.new(**args)
        end
      end

      new(requests)
    end

    def initialize(requests)
      @requests = requests
    end

    def each
      requests.each { |r| yield r }
    end

    private

    attr_reader :requests
  end
end
