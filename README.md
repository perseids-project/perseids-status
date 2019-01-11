# Perseids Status

Makes requests to various Perseids endpoints to check the status of the applications.

## View

[https://status.perseids.org](https://status.perseids.org)

## How to Use

Running the script `ruby test` will request the URLs, print the output to STDOUT and save the results to `index.json` and `index.html`.

Running `ruby test --record` will make the requests and save the responses in the `pages/` directory.
Future runs of `test` will compare against these responses.

See `ruby test --help` for more options.

## Requirements

* `ruby ~2.5.1`

## Installation

* `gem install bundler`
* `bundler install`

## Running tests

`bundle exec rspec`

## Linting the code

`bundle exec rubocop`
