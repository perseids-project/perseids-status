# Perseids Status

Makes requests to various Perseids endpoints to check the status of the applications.

## View

[https://status.perseids.org](https://status.perseids.org)

## How to Use

Running the script `ruby test.rb` will request the URLs, print the output to STDOUT and save the results to `index.json` and `index.html`.

Running `ruby test.rb --record` will make the requests and save the responses in the `pages/` directory.
Future runs of `test.rb` will compare against these responses.

## Requirements

Ruby ~2.0.0
