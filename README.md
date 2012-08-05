# Description
Provides LWRPs for interaction with Rackspace's Cloud DNS API using Fog

If you want to also manage your dns with cli commands I recommend you also use the [rsdns cookbook](http://community.opscode.com/cookbooks/rsdns) that this cookbook borrows databag structure from for a consistant experience interfacing with Rackspace products.

# Requirements
Requires Chef 0.7.10 or higher for Lightweight Resource and Provider support. Chef 0.8+ is recommended. While this cookbook can be used in chef-solo mode, to gain the most flexibility, we recommend using chef-client with a Chef Server.

## Library Requirements

The inner workings of the library depend on [fog](https://github.com/fog/fog) which we are using a [rackspace fork](http://rubygems.org/gems/rackspace-fog) of to handle wider linux distribution requirements (specifically Ubuntu 10.4 LTS). Installation is handled by inclusion of the cookbook.

A Rackspace Cloud Hosting account is required to use this tool.  And a valid `username` and `api_key` are required to
authenticate into your account.

You can get one here [sign-up](https://cart.rackspace.com/cloud/?cp_id=cloud_dns).

## General Requirements
* You need to either set the attributes for your Rackspace username and api key 
in attributes/default.rb or create an encrypted data bag per the following setup
 steps:


### Setup

Take either step depending on your databag setup.

#### I already have an encrypted_data_bag_secret file created and pushed out to your chef nodes
* Create the new encrypted data_bag
knife data bag create --secret-file <LOCATION/NAME OF SECRET FILE>  rackspace cloud

* Make the json file opened look like the following, then save and exit your editor:

```
{
  "id": "cloud",
  "raxusername": "<YOUR CLOUD SERVER USERNAME>",
  "raxapikey": "<YOUR CLOUD SERVER API KEY>",
  "raxregion": "<YOUR ACCOUNT REGION (us OR uk)>"
}
```

####I don't use an encrypted_data_bag_secret file
* Create a new secret file
`openssl rand -base64 512 | tr -d '\r\n' > /tmp/my_data_bag_key`

* The `/tmp/my_data_bag_key` (or whatever you called it in the above step) needs to be pushed out to your chef nodes to `/etc/chef/encrypted_data_bag_secret`

* Create the new encrypted data_bag
`knife data bag create --secret-file /tmp/my_data_bag_key rackspace cloud`

* Make the json file opened look like the following, then save and exit your editor:

```
{
  "id": "cloud",
  "raxusername": "<YOUR CLOUD SERVER USERNAME>",
  "raxapikey": "<YOUR CLOUD SERVER API KEY>",
  "raxregion": "<YOUR ACCOUNT REGION (us OR uk)>"
}
```

# Attributes

All attributes are namespaced under the `node[:rackspace_dns]` namespace.  This keeps everything clean and organized.

The following attributes are required, either in attributes/default.rb or an encrypted data bag called rackspace with an item of cloud:

* `['rackspace_dns']['rackspace_username']`
* `['rackspace_dns']['rackspace_api_key']`
* `['rackspace_dns']['rackspace_auth_region']`
** This must be set to either 'us' or 'uk', depending on where your account was 
created



# Usage

