class PerseidsStatus
  class Recorder
    def initialize(request_map, path)
      @request_map = request_map
      @path = File.join(__dir__, '..', '..', path)
    end

    def record!
      request_map.each do |request|
        filepath = File.join(path, request.test.to_s, request.name.to_s + '.html')

        Utils.write_file!(filepath, request.result)
      end
    end

    private

    attr_reader :request_map, :path
  end
end
