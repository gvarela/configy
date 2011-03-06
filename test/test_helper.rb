require 'rubygems'
require 'yaml'
require 'fileutils'
require 'test/unit'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'configy'

class Test::Unit::TestCase
end
