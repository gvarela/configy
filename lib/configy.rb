module Configy
  autoload :ConfigFile, 'configy/config_file'
  autoload :Configuration, 'configy/configuration'

  @@load_path = nil
  @@section = nil

  def self.load_path=(val)
    @@load_path = val
  end

  def self.section=(val)
    @@section = val
  end

  def self.load_path
    if @@load_path
      return @@load_path
    elsif defined? Rails
      return Rails.root.join("config")
    elsif defined? RAILS_ROOT
      return "#{RAILS_ROOT}/config"
    elsif defined? RACK_ROOT
      return "#{RACK_ROOT}/config"
    else
      return 'config'
    end
  end

  def self.section
    if @@section
      return @@section
    elsif defined? Rails
      return Rails.env
    elsif defined? RAILS_ENV
      return RAILS_ENV
    elsif defined? RACK_ENV
      return RACK_ENV
    else
      return 'development'
    end
  end

  def self.camelize(phrase)
    camelized = phrase.gsub(/^[a-z]|\s+[a-z]|_+[a-z]|-+[a-z]/i) { |a| a.upcase }
    camelized.gsub!(/\s/, '')
    camelized.gsub!(/_/, '')
    camelized.gsub!(/-/, '')
    return camelized
  end

  def self.create(file)
    Object.const_set( camelize(file.to_s), ConfigFile.new(file) )
  end
end