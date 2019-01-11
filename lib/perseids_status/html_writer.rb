require 'erb'

class PerseidsStatus
  class HTMLWriter
    def initialize(json, path = 'index.html')
      @json = json
      @path = File.join(__dir__, '..', '..', path)
    end

    def write!
      Utils.write_file!(path, content)
    end

    private

    attr_reader :json, :path

    def content
      ERB.new(template).result(binding)
    end

    def template
      <<~HTML
        <!DOCTYPE html>
        <html lang="en">
          <head>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Perseids Status</title>
            <style>
              html, body {
                height: 100%;
                font-family: Helvetica, Arial, sans-serif;
                font-size: 14px;
              }

              .header {
                margin-top: 20px;
                margin-bottom: 10px;
              }

              .header, .list {
                margin-left: auto;
                margin-right: auto;
                width: 400px;
              }

              .results {
                margin-bottom: 40px;
              }
            </style>
          </head>
          <body>
            <div class="header">
              <h1>Perseids Status</h1>
            </div>
            <div class="list">
              <% json.each do |result| %>
                <% location = result[:location] %>
                <div class="date">
                  <h3><%= location.split('-', 2).last %></h3>
                </div>

                <div class="results">
                  <% result.each do |test, pages| %>
                    <% next if test == :location %>
                    <div class="message">
                      <h4><%= test %></h4>

                      <table class="message-table">
                        <% pages.each do |name, result| %>
                          <tr>
                            <td class="check" width="25px"><%= (result == 'ok') ? '✅' : '❌' %></td>
                            <td class="name" width="200px"><%= name %></td>
                            <td class="status" width="30px"><%= result %></td>
                            <td class="source" width="30px">
                              <a href="pages/<%= test %>/<%= name %>.html" width="30px">old</a>
                            </td>
                            <td class="compare">
                              <a href="<%= location %>/<%= test %>/<%= name %>.html">new</a>
                            </td>
                          </tr>
                        <% end %>
                      </table>
                    </div>
                  <% end %>
                  <hr />
                </div>
              <% end %>
            </div>
          </body>
        </html>
      HTML
    end
  end
end
