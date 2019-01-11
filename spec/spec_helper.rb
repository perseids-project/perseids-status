require 'rspec/its'

# Require every Ruby file in the ../lib directory
Dir[File.join(__dir__, '..', 'lib', '**', '*.rb')].each { |file| require file }
