require 'test_helper'

class LoadPathTest < MiniTest::Unit::TestCase
  def setup
    Configy.load_path = nil
  end

  def test_should_default_to_config
    assert_equal "config", Configy.load_path
  end

  def test_should_detect_rails3_config_dir
    rails3_obj = MiniTest::Mock.new
    rails3_obj.expect :root, Pathname.new("path/to/rails/root")

    with_const(:Rails, rails3_obj) do
      assert_equal Rails.root.join("config"), Configy.load_path
    end
  end

  def test_should_detect_rails2_config_dir
    with_const( :RAILS_ROOT, "path/to/rails/root" ) do
      assert_equal "#{RAILS_ROOT}/config", Configy.load_path
    end
  end

  def test_should_detect_rack_config_dir
    with_const( :RACK_ROOT, "path/to/rack/root" ) do
      assert_equal "#{RACK_ROOT}/config", Configy.load_path
    end
  end
end