require 'rest_client'

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
  rescue LoadError
end

PORT_MAPPINGS='-p 8083:8083 -p 8086:8086 -p 80:80 -p 8084:8084 -p 8090:8090 -p 8099:8099'

IMAGE_NAME=File.basename(Dir.getwd)

task :build do
  puts "Building #{IMAGE_NAME} image..."
  system "docker build -t #{IMAGE_NAME} ."
end

task :deploy do
  puts "Deploying #{IMAGE_NAME} image..."
  system "docker run -d #{PORT_MAPPINGS} #{IMAGE_NAME} > pid"
end

task :destroy do
  puts "Destroying #{IMAGE_NAME} image..."
  system 'docker rm -f $(cat pid) && rm pid'
end

task :shell do
  puts "Going interactive with #{IMAGE_NAME} image..."
  system "docker run --rm #{PORT_MAPPINGS} -t -i #{IMAGE_NAME} /bin/bash > pid"
end

task default: [:spec]
