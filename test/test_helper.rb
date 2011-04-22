require 'rubygems'
require 'bundler/setup'
require 'minitest/autorun'
require 'minitest/mock'
require 'fileutils'
require 'pathname'
require 'configy'

module Configy::TestHelpers
  def assert_equal_with_hash(config, hash)
    hash.each do |key, value|
      assert_equal config.send(key), value
    end
  end

  def with_config_file(conf, file='config')
    path = file_path(file)
    File.open(path, 'w') { |f| f.write conf.is_a?(String) ? conf : conf.to_yaml }
    yield(path, conf)
  ensure
    FileUtils.rm path
  end

  def file_path(file)
    File.join(scratch_dir, "#{file}.yml")
  end

  def scratch_dir
    @scratch_dir ||= File.expand_path("../scratch", __FILE__)
  end

  def with_const(const, value)
    Object.const_set const, value
    yield
    Object.send :remove_const, const
  end

end

class MiniTest::Unit::TestCase
  include Configy::TestHelpers
end
