$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'kekka'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|

end

RSpec::Matchers.define :have_keys do |expected_keys|
  match do |hash|
    expected_keys.each {|one_key| hash[one_key].should_not be_nil }
  end
  # failure_message_for_should do |hash|
  #   "expected that each of [#{expected_keys.join(',')}] should be keys to: #{hash.inspect}"
  # end
end
