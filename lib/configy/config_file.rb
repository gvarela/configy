require 'pathname'
require 'erb'
require 'yaml'

module Configy
  class ConfigFile
    def initialize(path, section)
      @path    = Pathname.new(path)
      @section = section
    end

    def config
      ConfigStore.new(load_file).compile(@section)
    end

    def load_file
      YAML::load( ERB.new(@path.read).result )
    rescue Errno::ENOENT
      {}
    end

    def mtime
      @path.mtime
    rescue Errno::ENOENT
      Time.at(0)
    end
  end
end