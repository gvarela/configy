require 'test_helper'

class ConfigurationTest < MiniTest::Unit::TestCase

  def setup
    Configy.load_path = scratch_dir
  end

  def test_should_create_configuration_via_create
    with_config_file( {'common' => {'a' => '1', 'b' => '2' }}, 'some_config' ) do |file, hash|
      Configy.create('some_config')

      assert_raises RuntimeError do
        SomeConfig.oops
      end
    end
  end

end
