#
# Cookbook Name:: lamp
# Recipe:: database
#
# Copyright (c) 2014, The University of Queensland
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# * Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
# * Redistributions in binary form must reproduce the above copyright
# notice, this list of conditions and the following disclaimer in the
# documentation and/or other materials provided with the distribution.
# * Neither the name of the The University of Queensland nor the
# names of its contributors may be used to endorse or promote products
# derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE UNIVERSITY OF QUEENSLAND BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

host = node['lamp']['database']['host'] || 'localhost'
root_password = node['lamp']['database']['root_password']
raise "I need a database root password" unless root_password

include_recipe 'mysql::client'

# This is a workaround for a ChefDK 
# (https://github.com/opscode-cookbooks/database/issues/76)
package 'build-essential'
package 'libmysqlclient-dev'
chef_gem 'mysql'

if platform_family?('rhel', 'fedora') then
  mysqld = 'mysqld'
else
  mysqld = 'mysql'
end

mysql_service 'default' do
  allow_remote_root false
  remove_anonymous_users true
  remove_test_database true
  server_root_password root_password
  action :create
  notifies :enable, "service[#{mysqld}]", :delayed
end

