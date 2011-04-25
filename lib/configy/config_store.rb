unless Hash.new.respond_to?(:deep_merge)
  class Hash
    # Returns a new hash with +self+ and +other_hash+ merged recursively.
    def deep_merge(other_hash)
      dup.deep_merge!(other_hash)
    end

    # Returns a new hash with +self+ and +other_hash+ merged recursively.
    # Modifies the receiver in place.
    def deep_merge!(other_hash)
      other_hash.each_pair do |k,v|
        tv = self[k]
        self[k] = tv.is_a?(Hash) && v.is_a?(Hash) ? tv.deep_merge(v) : v
      end
      self
    end
  end
end

module Configy
  class ConfigStore
    attr_reader :config
    attr_accessor :mtime

    # Takes a Hash as input
    def initialize(config)
      @config = config && config.to_hash || {}
    end

    # Returns a new ConfigStore by merging `common` with `section`
    def compile(section)
      common   = @config['common'] || {}
      selected = @config[section]  || {}

      self.class.new( common.deep_merge(selected) )
    end

    # Merges two ConfigStore objects together by merging their hashes
    def merge(other)
      self.class.new( config.deep_merge(other.config) )
    end

    # Access to the stored configs
    def [](key)
      key = key.to_s

      if @config.key?(key)
        @config[key]
      else
        raise ConfigParamNotFound, key
      end
    end

    def to_hash
      @config
    end
  end
end

