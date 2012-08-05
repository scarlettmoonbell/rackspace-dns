begin
  require 'rackspace-fog'
rescue LoadError
  Chef::Log.warn("Missing gem 'rackspace-fog'")
end

module Rackspace
  module DNS

    def cdns

      if Chef::DataBag.list.keys.include?("rackspace") && data_bag("rackspace").
include?("cloud")
        #Access the Rackspace Cloud encrypted data_bag
        creds = Chef::EncryptedDataBagItem.load("rackspace", "cloud")
      else
        creds = {'raxusername' => nil, 'raxapikey' => nil }
      end

      apikey = new_resource.rackspace_api_key || creds['raxapikey']
      username = new_resource.rackspace_username || creds['raxusername']
      @@cdns ||= Fog::Monitoring::Rackspace.new(:rackspace_api_key => apikey, :rac
kspace_username => username)
      @@cdns
    end


end
