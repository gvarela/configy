require 'test_helper'

class ConfigyTest < Test::Unit::TestCase
  def setup
    @dir = File.dirname(__FILE__) + "/"
    @files = []
  end
  
  def test_should_read_from_yml
    test_config 'common' => {'a' => '1', 'b' => '2'} do |file, hash|
      config = Configy::Configuration.new(file)
      assert_equal_with_hash config, hash['common']
    end
  end
  
  def test_should_ignore_non_existent_file
    config = Configy::Configuration.new('nonexsistentfile')
    assert_not_nil config
  end
  
  def test_should_igonre_non_existent_section
    test_config 'common' => {'a' => '1', 'b' => '2' } do |file, hash|
      config = Configy::Configuration.new(file)
      config.use_section!('nonexistentsection')
      assert_equal config.b, '2'
    end    
  end
  
  def test_should_parse_yaml_with_erb
    test_config 'common' => {'a' => '1', 'b' => '<%= 2 + 2 %>' } do |file, hash|
      config = Configy::Configuration.new(file)
      assert_equal config.b, 4
    end
  end
  
  def test_should_override_params_with_given_section
    test_config 'common' => {'a' => '1', 'b' => '<%= 2 + 2 %>'}, 
                 'special' => {'a' => 1, 'b' => 5 } do |file, hash|
      config = Configy::Configuration.new(file)
      config.use_section!('special')
      assert_equal_with_hash config, hash['special']
    end
    test_config 'common' => {'a' => '1', 'b' => '<%= 2 + 2 %>'}, 
                'special' => {'b' => 5 } do |file, hash|
      config = Configy::Configuration.new(file)
      config.use_section!('special')
      assert_equal_with_hash config, {'a' => '1', 'b' => 5}
    end    
  end
  
  def test_should_ovveride_params_with_another_file
    test_config({'common' => {'a' => '1', 'b' => '<%= 2 + 2 %>'}, 
                 'special' => {'b' => 5 }}, 'config') do |file1, hash1|
      test_config({'common' => {'a' => '2'}, 
                   'special' => {'b' => 8 }}, 'config.local') do |file2, hash2|                
        config = Configy::Configuration.new(file1)
        assert_equal_with_hash config, {'a' => '1', 'b' => 4}
        config.use_file!(file2)
        assert_equal_with_hash config, {'a' => '2', 'b' => 4}
      end
    end        
  end
  
  def test_should_ovveride_params_with_another_file_and_use_proper_section
    test_config({'common' => {'a' => '1', 'b' => '<%= 2 + 2 %>', 'c' => 2}, 
                 'special' => {'b' => 5, 'd' => 6 },
                 'extra' => {'f' => 4, 'a' => 8}}, 'config') do |file1, hash1|
      test_config({'common' => {'a' => '2'}, 
                   'special' => {'b' => 8 }}, 'config.local') do |file2, hash2|                
        config = Configy::Configuration.new
        config.use_file!(file1)
        config.use_file!(file2)
        config.use_section!('special')
        assert_equal_with_hash config, {'a' => '2', 'b' => 8, 'c' => 2, 'd' => 6}
      end
    end        
  end 
  
  def test_camelize
    assert_equal 'Config', Configy.camelize('config')
    assert_equal 'SomeConfig', Configy.camelize('some_config')
    assert_equal 'SomeOtherConfig', Configy.camelize('some-other_config')
  end
  
  def test_should_create_configuration_via_create
    Configy.load_path = @dir
    test_config( {'common' => {'a' => '1', 'b' => '2' }}, 'some_config' ) do |file, hash|
      Configy.create('some_config')
      assert_equal SomeConfig.b, '2'
    end
  end 
  
  def teardown
    begin
      FileUtils.rm @files
    rescue
    end
  end
  
  protected
  
    def file_path(file)
      @dir + file + '.yml'
    end
  
    def create_config_file(file, hash) 
      file = @dir + file + '.yml'
      @files << file
      File.open(file, 'w') do |f|
        f.write hash.to_yaml        
      end
    end
    
    def assert_equal_with_hash(config, hash)    
      hash.each do |key, value|
        assert_equal config.send(key), value
      end
    end
    
    def test_config(hash, file = 'config', &blk)
      create_config_file file, hash
      blk.call(file_path(file), hash)
    end
end
