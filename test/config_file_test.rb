require 'test_helper'
require 'erb'

class ConfigFileTest < MiniTest::Unit::TestCase
  MAIN_CONFIG = <<-EOS
common:
  a: 1
  b: <%= 2 + 2 %>
  c: 2
special:
  b: 5
  d: 6
extra:
  f: 4
  a: 8
  EOS

  LOCAL_CONFIG = <<-EOS
common:
  a: '2'
special:
  b: 8
  EOS

  def setup
    Configy.load_path = scratch_dir
  end

  def test_should_override_params_with_another_file_and_use_proper_section
    Configy.section = "special"

    with_config_file(MAIN_CONFIG, 'config') do
      with_config_file(LOCAL_CONFIG, 'config.local') do
        config = Configy::ConfigFile.new('config')
        assert_equal '2', config.a
        assert_equal 8,   config.b
        assert_equal 2,   config.c
        assert_equal 6,   config.d
      end
    end
  end

end
