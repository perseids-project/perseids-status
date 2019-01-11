class PerseidsStatus
  class Reader
    def initialize(request_map, path)
      @request_map = request_map
      @path = File.join(__dir__, '..', '..', path)
    end

    def read_canonical!
      request_map.each do |request|
        request.canonical = read_request(request)
      end
    end

    def read_comparison!
      request_map.each do |request|
        request.result = read_request(request)
      end
    end

    private

    attr_reader :request_map, :path

    def read_request(request)
      File.read(File.join(path, request.test.to_s, request.name.to_s + '.html'))
    end
  end
end
