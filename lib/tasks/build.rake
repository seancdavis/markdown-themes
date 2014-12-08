require 'fileutils'
require 'yaml'

desc 'Build style config files'
task :build do

  root_path = File.expand_path('../../../', __FILE__)
  config_path = "#{root_path}/config"
  output_dir = "#{root_path}/styles/config"
  FileUtils.mkdir_p(output_dir)

  Dir.glob("#{output_dir}/*.scss").each { |file| FileUtils.rm(file) }

  Dir.glob("#{config_path}/*.yml").each do |file|
    theme = file.split('/').last.split('.').first
    if config = YAML.load_file(file)
      filename = "_#{theme}.scss"
      @output_file = "#{output_dir}/#{filename}"
      FileUtils.rm(@output_file) if File.exists?(@output_file)
      build_config(config)
      puts "\n== Compiled config file: styles/config/#{filename} ============="
    end
  end
end

def build_config(config, parents = nil)
  config.each do |key, value|
    if value.is_a?(Hash)
      new_parents = parents.nil? ? key : "#{parents}-#{key}"
      build_config(value, new_parents)
    else
      var = parents.nil? ? key : "#{parents}-#{key}"
      File.open(@output_file, 'a') { |f| f << "$#{var}: #{value};\n" }
    end
  end
end
