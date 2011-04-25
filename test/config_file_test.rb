require 'test_helper'

class ConfigFileTest < MiniTest::Unit::TestCase
  def test_should_load_a_config_from_a_file
    with_config_file( { 'common' => {'a' => '1', 'b' => '2' } }, 'app_config' ) do |file, hash|
      configfile = Configy::ConfigFile.new(file, 'development')
      assert_equal hash, configfile.load_file
    end
  end

  def test_should_create_an_instance_of_config_store
    with_config_file( { 'common' => {'a' => '1', 'b' => '2' } }, 'app_config' ) do |file, hash|
      configfile = Configy::ConfigFile.new(file, 'development')
      assert_instance_of Configy::ConfigStore, configfile.config
    end
  end

  def test_should_be_aware_of_a_files_mtime
    configfile = Configy::ConfigFile.new('nonexistent/file', 'development')
    assert_equal Time.at(0), configfile.mtime

    with_config_file( { 'common' => {'a' => '1', 'b' => '2' } }, 'app_config' ) do |file, hash|
      configfile = Configy::ConfigFile.new(file, 'development')
      assert_equal File.mtime(file), configfile.mtime
    end
  end

end
