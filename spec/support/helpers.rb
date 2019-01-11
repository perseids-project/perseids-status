require 'erb'

module Helpers
  def self.mock_file(time, mocks)
    template = <<~RUBY
      require 'webmock'

      WebMock.enable!

      <% mocks.each do |url, result| %>
        WebMock::API.stub_request(:any, <%= url.inspect %>).to_return(body: <%= result.inspect %>)
      <% end %>

      class Time
        def strftime(string)
          <%= time.inspect %>
        end
      end
    RUBY

    struct = Struct.new(:time, :mocks).new(time, mocks)
    ERB.new(template).result(struct.send(:binding))
  end
end
