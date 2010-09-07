# This script takes the "parameters" output from cobbler and converts it into facts
require 'net/http'
require 'yaml'

server = Net::HTTP.new('puppet',80)
this_host = Facter.fqdn 
headers,data = server.get("/cblr/svc/op/puppet/hostname/#{this_host}")
data_hash = YAML::load(data)

# create the "puppet_classes" fact
Facter.add('puppet_classes') do
	setcode do
		data_hash['classes']
	end
end

# setup the parameters
data_hash['parameters'].each do |key,value|
	Facter.add(key.lstrip()) do
		setcode do
			value
		end		
	end
end
