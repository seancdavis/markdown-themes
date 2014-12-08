require 'fileutils'

desc 'Create a new theme'
task :new, [:theme] do |t, args|
  if args[:theme].nil?
    puts "Usage: bundle exec rake new[THEME]"
    exit
  end

  theme = args[:theme]
  FileUtils.cp("config/default.yml", "config/#{theme}.yml")
  puts "\n== Copied config: config/#{theme}.yml ============="

  File.open("styles/#{theme}.scss", 'w+') do |f| 
    f << "@import 'config/#{theme}';\n"
    f << "@import 'base';"
  end
  puts "\n== Created theme: styles/#{theme}.scss ============="

  Rake::Task["build"].invoke
end
