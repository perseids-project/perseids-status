class PerseidsStatus
  class Printer
    def initialize(request_map)
      @request_map = request_map
    end

    def print
      request_map.each do |request|
        puts("#{request.test}/#{request.name} doesn't match (#{request.compare})") if request.differs?
      end
    end

    private

    attr_reader :request_map
  end
end
