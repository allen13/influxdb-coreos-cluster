require 'open-uri'
require 'yaml'

token = open('https://discovery.etcd.io/new').read
data = YAML.load(IO.readlines('cloud-config-template.yml')[1..-1].join)
data['coreos']['etcd']['discovery'] = token
yaml = YAML.dump(data)
File.open('cloud-config.yml', 'w') { |file| file.write("#cloud-config\n\n#{yaml}") }
