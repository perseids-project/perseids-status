require 'json'

class PerseidsStatus
  class JSONReader
    attr_reader :json

    def initialize(path = 'index.json')
      @path = File.join(__dir__, '..', '..', path)
    end

    def read!
      @json = if File.exist?(path)
        JSON.parse(File.read(path), symbolize_names: true)
      else
        []
      end
    end

    def location(version)
      raise JSONVersionNotFound if json.empty?

      result = json.find { |j| j[:location] == version }

      raise JSONVersionNotFound unless result

      result[:location]
    end

    class JSONVersionNotFound < StandardError
    end

    private

    attr_reader :path
  end
end
