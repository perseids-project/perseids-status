# Perseids Status

Makes requests to various Perseids endpoints to check the status of the applications.

## View

[https://status.perseids.org](https://status.perseids.org)

## How to Use

Running the script `ruby status` will request the URLs, print the output to STDOUT and save the results to `index.json` and `index.html`.

Running `ruby status --record` will make the requests and save the responses in the `pages/` directory.
Future runs of `status` will compare against these responses.

See `ruby status --help` for more options.

## Requirements

* `ruby ~2.5.1`

## Installation

* `gem install bundler`
* `bundle install`

## Running tests

`bundle exec rspec`

## Linting the code

`bundle exec rubocop`
