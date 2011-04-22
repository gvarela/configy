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
  e: <%= 6 * 7 %>
  EOS

  def test_top_level_configs_should_be_accesssible_as_methods
    with_config_file(MAIN_CONFIG, 'config') do
      config = Configy::Base.new('config', 'special', scratch_dir)
      assert_equal 1, config.a
    end
  end

  def test_method_missing
    config = Configy::Base.new('config', 'special', scratch_dir)
    assert_raises NoMethodError do
      config.nope = "oops"
    end
  end

  def test_should_override_params_with_another_file_and_use_proper_section
    with_config_file(MAIN_CONFIG, 'config') do
      with_config_file(LOCAL_CONFIG, 'config.local') do
        config = Configy::Base.new('config', 'special', scratch_dir)
        assert_equal '2', config.a
        assert_equal 8,   config.b
        assert_equal 2,   config.c
        assert_equal 6,   config.d
        assert_equal 42,  config.e
      end
    end
  end

  def test_should_reload_a_config_file_if_changed
    with_config_file({ 'common' => {'a' => 'foo'} }, 'config') do |file1, hash1|
      with_config_file({ 'special' => {'b' => 'bar'} }, 'config.local') do |file2, hash2|

        config = Configy::Base.new('config', 'special', scratch_dir)
        assert_equal 'foo', config.a
        assert_equal 'bar', config.b

        # Simulate 1 second going by
        config.send(:compiled_config).mtime -= 1

        File.open(file1, 'w') do |f|
          f.puts( {'common' => {'a' => 'foo*'} }.to_yaml )
        end

        assert_equal 'foo*', config.a

        # Simulate 1 second going by
        config.send(:compiled_config).mtime -= 1

        File.open(file2, 'w') do |f|
          f.puts( {'special' => {'b' => 'bar*'} }.to_yaml )
        end

        assert_equal 'bar*', config.b

      end
    end
  end
end
