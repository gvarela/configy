module Configy
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)
  
    def copy_initializer_file # :nodoc:
      template "config/initializers/configy.rb.tt", "config/initializers/configy.rb"
    end
    
    def copy_config_file # :nodoc:
      template "config/app_config.yml.tt", "config/app_config.yml"
    end

    def copy_local_config_file # :nodoc:
      template "config/app_config.local.yml.tt", "config/app_config.local.yml"
      insert_into_file ".gitignore", "\nconfig/*.local.yml", :before => /\z/
    end

  end
end