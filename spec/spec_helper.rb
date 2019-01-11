require 'rspec/expectations'
require 'rspec/its'

require 'fileutils'
require 'pathname'
require 'tmpdir'
require 'webmock/rspec'

require 'support/factory'
require 'support/fixture'
require 'support/helpers'

require 'perseids_status'

RSpec::Matchers.define :be_the_same_path_as do |expected|
  match do |actual|
    Pathname.new(expected).cleanpath == Pathname.new(actual).cleanpath
  end
end
RSpec::Matchers.alias_matcher :the_same_path_as, :be_the_same_path_as
