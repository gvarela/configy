require 'test_helper'

class SectionTest < MiniTest::Unit::TestCase
  def setup
    Configy.section = nil
  end

  def test_should_default_to_development
    assert_equal "development", Configy.section
  end

  def test_should_detect_rails3_environment
    rails3_obj = MiniTest::Mock.new
    rails3_obj.expect :env, "staging"

    with_const(:Rails, rails3_obj) do
      assert_equal "staging", Configy.section
    end
  end

  def test_should_detect_rails2_environment
    with_const( :RAILS_ENV, "test" ) do
      assert_equal "test", Configy.section
    end
  end

  def test_should_detect_rack_environment
    with_const( :RACK_ENV, "production" ) do
      assert_equal "production", Configy.section
    end
  end

  def test_should_be_able_to_override
    Configy.section = "custom"
    assert_equal "custom", Configy.section
  end
end