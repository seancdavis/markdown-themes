require 'fileutils'
require 'yaml'

desc 'Build style config files'
task :build do

  root_path = File.expand_path('../../../', __FILE__)
  config_path = "#{root_path}/config"

  Dir.glob("#{config_path}/**/*.yml").each do |file|
    theme = file.split('/')[-2]
    if config = YAML.load_file(file)
      output_dir = "#{root_path}/styles/config"
      filename = "_#{theme}.scss"
      @output_file = "#{output_dir}/#{filename}"
      FileUtils.rm(@output_file) if File.exists?(@output_file)
      FileUtils.mkdir_p(output_dir)
      build_config(config)
      puts "\n== Wrote new file: #{filename} ============="
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
