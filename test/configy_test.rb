require 'test_helper'

class ConfigyTest < MiniTest::Unit::TestCase

  def setup
    Configy.load_path    = scratch_dir
    Configy.cache_config = nil
  end

  def test_camelize
    assert_equal 'Config', Configy.camelize('config')
    assert_equal 'SomeConfig', Configy.camelize('some_config')
    assert_equal 'SomeOtherConfig', Configy.camelize('some-other_config')
  end

  def test_should_create_a_configuration_class_based_on_a_yaml_file
    with_config_file( {'common' => {'a' => '1', 'b' => '2' }}, 'app_config' ) do |file, hash|
      Configy.create('app_config')
      assert Object.const_defined?(:AppConfig)
      assert_equal AppConfig.b, '2'
    end
  end

  def test_should_create_a_configuration_class_based_on_a_yaml_file_within_a_parent_module
    with_config_file( {'common' => {'a' => '1', 'b' => '2' }}, 'app_config' ) do |file, hash|
      Object.const_set('MyApp', Module)
      Configy.create('app_config', MyApp)
      assert MyApp.const_defined?(:AppConfig)
      assert_equal MyApp::AppConfig.b, '2'
    end
  end

  def test_cache_config_always_defaults_to_false
    Configy.section = 'production'
    assert_equal false, Configy.cache_config

    Configy.section = 'development'
    assert_equal false, Configy.cache_config
  end

  def test_should_be_able_to_manually_set_cache_config
    Configy.cache_config = true
    Configy.create('dummy')

    assert_equal true, Configy.cache_config
    assert_equal true, Dummy.cache_config?
  end

end
