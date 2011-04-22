require 'pathname'

module Configy
  class Base
    def initialize(filename, section, load_path, cache_config=false)
      @load_path    = load_path    # Directory where config file(s) live
      @section      = section      # Section of the config file to use
      @filename     = filename     # Filename of the config
      @cache_config = cache_config # Whether to cache the config or reload when stale
    end

    def method_missing(name, *args, &block)
      if args.size.zero?
        reload if !cache_config? && stale?
        config[name]
      else
        super
      end
    end

    def reload
      @config = config_file.config.merge(local_config_file.config).tap do |c|
        c.mtime = most_recent_mtime
      end
    end

    def cache_config?
      @cache_config
    end

    protected

    def config
      @config ||= reload
    end

    # Represents config file, ie (config/app_config.yml)
    def config_file
      @config_file ||= ConfigFile.new(config_path, @section)
    end

    # Represents local override file, ie (config/app_config.local.yml)
    def local_config_file
      @local_config_file ||= ConfigFile.new(local_config_path, @section)
    end

    def config_path
      @file_path ||= Pathname.new(@load_path) + "#{@filename}.yml"
    end

    def local_config_path
      @local_file_path ||= Pathname.new(@load_path) + "#{@filename}.local.yml"
    end

    def stale?
      config.mtime < most_recent_mtime
    end

    def most_recent_mtime
      [config_file.mtime, local_config_file.mtime].max
    end
  end
end