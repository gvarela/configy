require 'pathname'

module Configy
  class Base
    def initialize(filename, section, load_path)
      @load_path = load_path # Directory where config file(s) live
      @section   = section   # Section of the config file to use
      @filename  = filename  # Filename of the config
    end

    # FIXME: We are doing a system call (File.mtime) every time a config
    # value is accessed. Perhaps keep a last checked value and only check
    # after some time has passed?
    def method_missing(name, *args, &block)
      if args.size.zero?
        compile if should_compile?
        @compiled_config[name]
      else
        super
      end
    end

    protected

    def compiled_config
      @compiled_config || compile
    end

    def compile
      @compiled_config = config_file.config.merge(local_config_file.config).tap do |c|
        c.mtime = most_recent_mtime
      end
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

    def should_compile?
      compiled_config.mtime < most_recent_mtime
    end

    def most_recent_mtime
      [config_file.mtime, local_config_file.mtime].max
    end
  end
end