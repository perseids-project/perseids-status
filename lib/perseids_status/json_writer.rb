require 'json'

class PerseidsStatus
  class JSONWriter
    def initialize(request_map, count, comparison_path, json, json_path: 'index.json')
      @request_map = request_map
      @count = count
      @comparison_path = comparison_path
      @json = json
      @json_path = File.join(__dir__, '..', '..', json_path)
    end

    def write!
      @json = [request_map_json] + json
      @json_removed = json[count..-1] || []
      @json = json[0...count]

      Utils.write_file!(json_path, JSON.pretty_generate(json) + "\n")
    end

    def clear!
      json_removed.each do |result|
        Utils.remove_dir!(File.join(__dir__, '..', '..', result[:location]))
      end
    end

    private

    attr_reader :request_map, :count, :json, :json_removed, :comparison_path, :json_path

    def request_map_json
      result = { location: comparison_path }

      request_map.each do |request|
        result[request.test] ||= {}
        result[request.test][request.name] = request.differs? ? request.compare : 'ok'
      end

      result
    end
  end
end
