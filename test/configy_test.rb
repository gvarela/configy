require 'test_helper'

class ConfigyTest < MiniTest::Unit::TestCase

  def setup
    Configy.load_path = scratch_dir
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

end
