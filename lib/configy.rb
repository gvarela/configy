module Configy
  autoload :Base, 'configy/base'
  autoload :ConfigFile, 'configy/config_file'
  autoload :ConfigStore, 'configy/config_store'

  class ConfigyError < StandardError; end
  class ConfigParamNotFound < ConfigyError; end

  class << self
    attr_writer :load_path, :section, :cache_config

    def load_path
      if @load_path
        @load_path
      elsif defined? Rails
        Rails.root.join("config")
      elsif defined? RAILS_ROOT
        "#{RAILS_ROOT}/config"
      elsif defined? RACK_ROOT
        "#{RACK_ROOT}/config"
      else
        'config'
      end
    end

    def section
      if @section
        @section
      elsif defined? Rails
        Rails.env
      elsif defined? RAILS_ENV
        RAILS_ENV
      elsif defined? RACK_ENV
        RACK_ENV
      else
        'development'
      end
    end

    # By default, only cache the config when section is production
    def cache_config
      if @cache_config
        @cache_config
      else
        section == 'production'
      end
    end
  end

  def self.camelize(phrase)
    camelized = phrase.gsub(/^[a-z]|\s+[a-z]|_+[a-z]|-+[a-z]/i) { |a| a.upcase }
    camelized.gsub!(/\s/, '')
    camelized.gsub!(/_/, '')
    camelized.gsub!(/-/, '')
    return camelized
  end

  # The main interface for creating Configy instances
  def self.create(file)
    Object.const_set( camelize(file.to_s), Configy::Base.new(file, section, load_path, cache_config) )
  end
end
