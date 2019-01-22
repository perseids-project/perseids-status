class PerseidsStatus
  class Requester
    def initialize(request_map)
      @request_map = request_map
    end

    def make_requests!
      request_map.each do |request|
        request.result = Utils.curl(request.url)
      end
    end

    private

    attr_reader :request_map
  end
end
