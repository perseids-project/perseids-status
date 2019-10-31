require 'fileutils'
require 'net/http'
require 'uri'

class PerseidsStatus
  module Utils
    def self.curl(url)
      Net::HTTP.get_response(URI.parse(url)).body
    rescue StandardError => e
      e.to_s
    end

    def self.write_file!(path, content)
      dirpath = File.dirname(path)

      FileUtils.mkdir_p(dirpath)
      File.open(path, 'w') { |file| file.write(content) }
    end

    def self.remove_dir!(path)
      FileUtils.rm_r(path) if File.exist?(path)
    end
  end
end
