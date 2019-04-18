require_relative 'perseids_status/emailer'
require_relative 'perseids_status/html_writer'
require_relative 'perseids_status/json_reader'
require_relative 'perseids_status/json_writer'
require_relative 'perseids_status/printer'
require_relative 'perseids_status/reader'
require_relative 'perseids_status/recorder'
require_relative 'perseids_status/request'
require_relative 'perseids_status/request_map'
require_relative 'perseids_status/requester'
require_relative 'perseids_status/utils'

class PerseidsStatus
  def initialize(config)
    @request_map = RequestMap.from_hash(config)
    @canonical_path = 'canonical'
    @comparison_path = "comparison-#{Time.now.strftime('%FT%H%M%LZ')}"
  end

  def make_requests!
    Requester.new(request_map).make_requests!

    self
  end

  def record_canonical!
    Recorder.new(request_map, canonical_path).record!

    self
  end

  def record_comparison!
    Recorder.new(request_map, comparison_path).record!

    self
  end

  def read_canonical!
    Reader.new(request_map, canonical_path).read_canonical!

    self
  end

  def read_comparison!(version)
    path = if version == 'current'
      comparison_path
    else
      json_reader = JSONReader.new
      json_reader.read!
      json_reader.location(version)
    end

    Reader.new(request_map, path).read_comparison!

    self
  end

  def print_results
    Printer.new(request_map).print

    self
  end

  def write_json_and_html!(count)
    write_json!(count)
    write_html!

    self
  end

  def send_email!(email, server, port, domain)
    Emailer.new(request_map, email, server, port, domain).send!

    self
  end

  private

  def write_json!(count)
    reader = JSONReader.new
    reader.read!

    writer = JSONWriter.new(request_map, count, comparison_path, reader.json)
    writer.write!
    writer.clear!
  end

  def write_html!
    reader = JSONReader.new
    reader.read!

    HTMLWriter.new(reader.json, request_map).write!
  end

  attr_reader :request_map, :canonical_path, :comparison_path
end
