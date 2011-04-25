require 'test_helper'

class ConfigStoreTest < MiniTest::Unit::TestCase
  def test_should_initialize_with_a_hash
    hash   = {'common' => {'a' => 1, 'b' => 2} }
    config = Configy::ConfigStore.new(hash)
    assert_equal hash, config.to_hash
  end

  def test_should_compile_a_selected_section_with_the_common_section
    hash1 = {
      'common'      => { 'a' => "A",  'b' => "B" },
      'development' => { 'a' => "A*", 'c' => "C" }
    }

    config = Configy::ConfigStore.new(hash1).compile('development')

    assert_equal "A*", config['a']
    assert_equal "B",  config['b']
    assert_equal "C",  config['c']
  end

  def test_should_merge_two_configs_together
    hash1 = {
      'common'      => { 'a' => "A",  'b' => "B", 'c' => "C" },
      'development' => { 'a' => "A*", 'c' => "C*", 'd' => "D", 'e' => "E" }
    }

    hash2 = {
      'common'      => { 'c' => "C**", 'f' => "F" },
      'development' => { 'e' => "E*" }
    }

    config1 = Configy::ConfigStore.new(hash1).compile('development')
    config2 = Configy::ConfigStore.new(hash2).compile('development')
    config  = config1.merge(config2)

    assert_equal "A*",  config['a']
    assert_equal "B",   config['b']
    assert_equal "C**", config['c']
    assert_equal "D",   config['d']
    assert_equal "E*",  config['e']
    assert_equal "F",   config['f']
  end

  def test_should_raise_an_exception_if_config_is_missing
    assert_raises Configy::ConfigParamNotFound do
      Configy::ConfigStore.new({})['oops']
    end
  end

end
