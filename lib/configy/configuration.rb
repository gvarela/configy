require 'erb'
require 'yaml'

module Configy
  class Configuration

    def initialize(file=nil)
      @sections, @params = {}, {}
      use_file!(file) if file
    end

    def use_file!(file)
      begin
        hash = YAML::load(ERB.new(IO.read(file)).result)
        merge(hash)
      rescue
      end
    end

    def merge(other)
      @sections.merge!(other) do |key, old_val, new_val|
        (old_val || new_val).merge(new_val)
      end

      @params.merge!(@sections['common'])
    end

    def use_section!(section)
      @params.merge!(@sections[section.to_s]) if @sections.key?(section.to_s)
    end

    def method_missing(param)
      param = param.to_s
      if @params.key?(param)
        @params[param]
      else
        raise "Invalid Configy::Configuration Parameter " + param
      end
    end

  end
end