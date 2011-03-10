require 'rubygems'
require 'yaml'
require 'fileutils'
require 'test/unit'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'configy'

class Test::Unit::TestCase

  def assert_equal_with_hash(config, hash)
    hash.each do |key, value|
      assert_equal config.send(key), value
    end
  end

  def with_config_file(hash, file='config')
    path = file_path(file)
    File.open(path, 'w') { |f| f.write hash.to_yaml }
    yield(path, hash)
  ensure
    FileUtils.rm path
  end

  def file_path(file)
    File.join(scratch_dir, "#{file}.yml")
  end

  def scratch_dir
    @scratch_dir ||= File.expand_path("../scratch", __FILE__)
  end
end
