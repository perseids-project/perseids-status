#!/usr/bin/env ruby
# Run with ruby 2.4.1

require 'json'
require 'optparse'

tests = {
  annotation: {
    arethusa: 'http://arethusa.perseids.org/app',
    arethusa_configs: 'http://arethusa-configs.perseids.org/vortex.json',
    arethusa_configs_list: { url: 'http://arethusa-configs.perseids.org/', compare: :wc },
    arethusa_dist: { url: 'http://arethusa.perseids.org/dist/arethusa.min.css', compare: :wc },
    bodin: 'http://pubs.perseids.org/bodin/',
    imgcollect: 'http://jackson.perseids.org/apps/imgcollect/index.html',
    imgup: 'http://imgup.perseids.org/upload-mnt/2015/JAN/080461031_1.jpg',
    jackson: 'http://jackson.perseids.org/data/upload/urn:cite:perseus:upload.irt1',
    joth: 'http://joth.perseids.org/joth.html#index',
    marmotta: { url: 'http://annotation.perseids.org/marmotta/sparql/select?query=SELECT+%3Fg+%3Fs+%3Fp+%3Fo+WHERE+%7B+values+%3Fg+%7B+%3Chttp%3A%2F%2Fannotation.perseids.org%2Fmarmotta%2Fldp%2Fb3JnLnBlcnNlaWRzL1RvcGljL1RyZWViYW5rQ2l0ZUlkZW50aWZpZXIvdXJuOmN0czpsYXRpbkxpdDpwaGkwNjkwLnBoaTAwMy5wZXJzZXVzLWxhdDI%3D%3E+%7D+GRAPH+%3Fg+%7B+%3Fs+%3Fp+%3Fo+%7D+%7D', headers: 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8' },
    pca_alignment: 'http://pca.perseids.org/apps/alignment',
    pca_treebank: 'http://pca.perseids.org/apps/treebank',
    pubs: 'http://pubs.perseids.org/alignment-prototypes/poetics/align.902.1.xhtml',
    www: 'https://www.perseids.org/',
  },
  ci: {
    ci: 'http://ci.perseids.org',
    ci_pull: 'http://ci.perseids.org/repo/OpenGreekAndLatin/First1KGreek/829',
  },
  collections: {
    collections: 'http://collections.perseids.org/',
    collections_element: 'http://collections.perseids.org/collections/org.perseids%2FTopic%2FTreebankCiteIdentifier%2Furn%3Acts%3AlatinLit%3Aphi0690.phi003.perseus-lat2',
  },
  digmill: {
    digmill: { url: 'https://digmill.perseids.org/', compare: :wc },
    digmill_entry: { url: 'https://digmill.perseids.org/commentary/100', compare: :wc },
  },
  morph: {
    morph_grk: { url: 'http://morph.perseids.org/analysis/word?lang=grc&engine=morpheusgrc&word=i(stori/hs', compare: :wc },
    morph_lat: { url: 'https://morph.perseids.org/analysis/word?lang=lat&engine=morpheuslat&word=novarum', compare: :wc },
  },
  other: {
    arethusa_treebank: 'https://www.perseids.org/tools/arethusa/app/#/perseids?chunk=1&doc=57532',
    imgup_redirect: 'http://www.perseids.org/imgup/upload-mnt/2015/JAN/080461031_1.jpg',
    jackson_redirect: 'http://www.perseids.org/jackson/data/upload/urn:cite:perseus:upload.irt1',
    proxy: { url: 'http://services.perseids.org/bsp/morphologyservice/analysis/word?lang=grc&engine=morpheusgrc&word=a)/sth', compare: :wc },
    sosol_treebank: 'http://www.perseids.org/tools/arethusa/app/#/perseids?chunk=1&doc=28581',
  },
  services: {
    capitains: { url: 'https://cts.perseids.org/read/greekLit/tlg0317/tlg002/1st1K-grc1/2-44', compare: :wc },
    capitains_api: 'https://cts.perseids.org/api/cts/?request=GetPassage&urn=urn:cts:greekLit:tlg0317.tlg002.1st1K-grc1:2-44',
    cite_mapper: 'http://services.perseids.org/cite_mapper/find_cite?cite=urn:cts:greekLit:tlg0085.tlg004.perseus-grc2',
    citefusioncoll: 'http://services.perseids.org/collections/testPage',
    fghproxy_gh: 'http://fgh.perseids.org/flask-github-proxy/perseids_syriaca/',
    fuseki: { url: 'http://fuseki.perseids.org/fuseki/ds/query?query=select%20%3Fresult%20%3Furl%20where%20%7B%3Fresult%20%3Chttp%3A%2F%2Fwww.cidoc-crm.org%2Fcidoc-crm%2FP138_represents%3E%20%3Curn%3Acts%3AlatinLit%3Aphi1038.phi001%3E%20.%3Fresult%20%3Chttp%3A%2F%2Fwww.homermultitext.org%2Fcite%2Frdf%2FbelongsTo%3E%20%3Fcollection%20.%20%3Fcollection%20%3Chttp%3A%2F%2Fdata.perseus.org%2Frdfvocab%2Fcite%2FimageServer%3E%20%3Furl%20.%7D&format=json', compare: :wc },
    llt: 'http://services.perseids.org/llt//tokenize?text=homo%20mittit.',
    sg: 'http://services.perseids.org/sg/body.1_div1.4_div2.14.html',
  },
  sosol: {
    sosol: { url: 'https://sosol.perseids.org/sosol/', compare: :wc },
    sosol_align: 'http://sosol.perseids.org/alpheios/xq/align-getlist.xq?doc=align.3326.1',
  },
}

def curl(url, headers: nil)
  if headers
    `curl -s -H '#{headers}' '#{url}'`
  else
    `curl -s '#{url}'`
  end
end

def timestamp
  format = "%FT%H%MZ"

  Time.now.strftime(format)
end

def write_file(name, bundle, location)
  options = {}
  url = bundle

  if bundle.is_a?(Hash)
    options[:headers] = bundle[:headers] if bundle[:headers]
    url = bundle[:url]
  end

  `mkdir -p #{location}`
  File.open("#{location}/#{name}.html", 'w') { |f| f.write(curl(url, **options)) }
end

def remove_data(results)
  results.each do |output|
    `rm -r #{output["location"]}`
  end
end

def record(tests)
  tests.each do |test, pages|
    pages.each { |name, bundle| write_file(name, bundle, "pages/#{test}") }
  end
end

def record_and_compare(tests, count)
  location = "compare-#{timestamp}"

  tests.each do |test, pages|
    pages.each { |name, bundle| write_file(name, bundle, "#{location}/#{test}") }
  end

  compare(tests, location, count)
end

def compare(tests, location, count)
  output = { location: location }

  tests.each do |test, pages|
    output[test] = {}

    pages.each do |name, bundle|
      compare = :diff

      if bundle.is_a?(Hash)
        url = bundle[:url]
        compare = bundle[:compare] if bundle[:compare]
      end

      file = "#{test}/#{name}"

      f1 = File.read("pages/#{file}.html")
      f2 = File.read("#{location}/#{file}.html")

      case compare
      when :diff
        if f1 != f2
          output[test][name] = "diff"
        else
          output[test][name] = "ok"
        end
      when :wc
        if f1.size != f2.size
          output[test][name] = "wc"
        else
          output[test][name] = "ok"
        end
      end
    end
  end

  results = []
  if File.exist?("index.json")
    results = JSON.parse(File.read("index.json"))
  end

  results.unshift(output)
  remove_data(results[count..-1] || [])
  results = results[0...count]

  File.open("index.json", "w") do |file|
    file.puts(JSON.pretty_generate(results))
  end
end

def print_output
  results = JSON.parse(File.read("index.json"))
  previous = results[0]

  previous.each do |test, pages|
    next if test == "location"

    pages.each do |name, result|

      file = "#{test}/#{name}"

      case result
      when "diff"
        puts "#{file} doesn't match (diff)"
      when "wc"
        puts "#{file} doesn't match (wc)"
      end
    end
  end
end

def html_output
  results = JSON.parse(File.read("index.json"))

  html = %Q{
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
          #{
            results.map do |output|
              location = output["location"]
              date = location.split("-", 2).last

              %Q{
                <div class="date">
                  <h3>#{date}</h3>
                </div>
                <div class="results">
                  #{
                    output.map do |test, pages|
                      next if test == "location"

                      %Q{
                        <div class="message">
                          <h4>#{test}</h4>

                          <table class="message-table">
                            #{
                              pages.map do |name, result|
                                %Q{
                                  <tr>
                                    <td class="check" width="25px">#{result == "ok" ? "✅" : "❌"}</td>
                                    <td class="name" width="200px">#{name}</td>
                                    <td class="status" width="30px">#{result}</td>
                                    <td class="source" width="30px">
                                      <a href="pages/#{test}/#{name}.html" width="30px">old</a>
                                    </td>
                                    <td class="compare">
                                      <a href="#{location}/#{test}/#{name}.html">new</a>
                                    </td>
                                  </tr>
                                }
                              end.join("\n")
                            }
                          </table>
                        </div>
                      }
                    end.join("\n")
                  }
                  <hr />
                </div>
              }
            end.join("\n")
          }
        </div>
      </body>
    </html>
  }.strip

  File.open("index.html", "w") { |file| file.puts(html) }
end

options = { count: 10 }
parser = OptionParser.new do |opts|
  opts.banner = "Usage: test.rb [options]"

  opts.on("-r", "--record", "Record responses") do
    options[:record] = true
  end

  opts.on("-t", "--test", "Test responses (default)") do
    options[:test] = true
  end

  opts.on("-c", "--count NUMBER", OptionParser::DecimalInteger, "Specify number of records (default 10)") do |c|
    options[:count] = c
  end

  opts.on("-h", "--help", "Show this message") do
    options[:help] = true

    puts opts
  end
end.parse!

if options[:help]
elsif options[:record]
  record(tests)
else
  record_and_compare(tests, options[:count])
  print_output
  html_output
end
