#
# Cookbook Name:: rackspace-dns
# Recipe:: default
#
# Copyright 2012, Joshua Bell
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#


r = gem_package "rackspace-fog" do
  version node['rackspace_dns']['version']
  action :nothing
end

r.run_action(:install)

require 'rubygems'
Gem.clear_paths
require 'rackspace-fog'

if Chef::DataBag.list.keys.include?("rackspace") && data_bag("rackspace").includ
e?("cloud")
  #Access the Rackspace Cloud encrypted data_bag
  raxcloud = Chef::EncryptedDataBagItem.load("rackspace","cloud")

  #Create variables for the Rackspace Cloud username and apikey
  node['rackspace_dns']['rackspace_username'] = raxcloud['raxusername']
  node['rackspace_dns']['rackspace_api_key'] = raxcloud['raxapikey']
  node['rackspace_dns']['rackspace_auth_region'] = raxcloud['raxregion'] || '
notset'
  node['rackspace_dns']['rackspace_auth_region'] = node['rackspace_dns']['
rackspace_auth_region'].downcase

  if node['rackspace_dns']['rackspace_auth_region'] == 'us'
    node['rackspace_dns']['rackspace_auth_url'] = 'https://identity.api.racks
pacecloud.com/v2.0'
  elsif node['rackspace_dns']['rackspace_auth_region']  == 'uk'
    node['rackspace_dns']['rackspace_auth_url'] = 'https://lon.identity.api.r
ackspacecloud.com/v2.0'
  else
    Chef::Log.info "Using the encrypted data bag for rackspace cloud but no raxr
egion attribute was set (or it was set to something other then 'us' or 'uk'). As
suming 'us'. If you have a 'uk' account make sure to set the raxregion in your d
ata bag"
    node['rackspace_dns']['rackspace_auth_url'] = 'https://identity.api.racks
pacecloud.com/v2.0'
  end
end

if node[:rackspace_dns][:rackspace_username] == 'your_rackspace_username' || 
node['rackspace_dns']['rackspace_api_key'] == 'your_rackspace_api_key'
  Chef::Log.info "Rackspace username or api key has not been set. For this to wo
rk, either set the default attributes or create an encrypted databag of rackspac
e cloud per the cookbook README"
end
