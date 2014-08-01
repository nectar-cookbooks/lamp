#
# Cookbook Name:: lamp
# Recipe:: pmwiki_authuserdbase
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

pmwiki_dir = node['apache']['docroot_dir']
cookbook_dir = "#{pmwiki_dir}/pmwiki/cookbook"
local_dir = "#{pmwiki_dir}/pmwiki/local"
version = node['lamp']['pmwiki']['authuserdbase']['version']
act = node['lamp']['pmwiki']['action']
auto = node['lamp']['pmwiki']['auto_config']

password = node['lamp']['pmwiki']['authuserdbase']['db_password']
raise "I need the password for the pmwiki db user" unless password

database = node['lamp']['pmwiki']['authuserdbase']['database']
node.normal['lamp']['adodb']['databases'][database] = {
  'driver' => 'mysql',
  'database' => database,
  'hostname' => node['lamp']['pmwiki']['authuserdbase']['db_host'],
  'username' => node['lamp']['pmwiki']['authuserdbase']['db_user'],
  'password' => password
}

include_recipe "lamp::pmwiki_database_standard"

authuserdbase_url = "http://www.pmwiki.org/pmwiki/uploads/Cookbook/AuthUserDbase-#{version}.php"

case act 
when 'install', 'upgrade'
else
  raise "Unknown action #{act}"
end

if act == 'install' && ::File.exists?("#{cookbook_dir}/authuserdbase.php") then
  log "AuthUserDbase already installed" do
    level :info
  end
else
  ruby_block "Check cookbook dir exists" do
    block do
      unless ::File.exists?(cookbook_dir) then
        raise "The PMWiki cookbook directory (#{cookbook_dir}) does not exist" 
      end
    end
  end

  directory '/opt/pmwiki' do
    recursive true
  end
end
  
remote_file "#{cookbook_dir}/authuserdbase.php" do
  source authuserdbase_url
  action if act == 'install' ? :create_if_missing : :create
end

if auto then
  template "#{local_dir}/20-authuserdbase.php" do
    source "authuserdbase_conf.php.erb"
    action :create_if_missing
  end
end

if node['lamp']['pmwiki']['authuserdbase']['standalone'] then
  root_password = node['lamp']['adodb']['root_password']
  raise "I need a mysql root password" unless root_password
  
  mysql_service 'default' do
    allow_remote_root false
    remove_anonymous_users true
    remove_test_database true
    server_root_password root_password
    action :create
  end

  connection_info = {
    :host => '127.0.0.1',
    :username => 'root',
    :password => root_password
  }

  mysql_database 'pmwiki database' do
    database_name database
    connection connection_info
    action :create
    notifies :query, "mysql_database[userdb_schema]", :immediately
    notifies :create, "mysql_database_user[pmwiki]", :immediately
  end

  mysql_database 'userdb_schema' do
    database_name database
    sql <<END
        CREATE TABLE `pmwiki_users` (
          `id` int(11) NOT NULL auto_increment,
          `username` varchar(30) NOT NULL default '',
          `password` varchar(60) default NULL,
          `validatecode` varchar(60) default NULL,
          `signupdate` date default NULL,
          `email` varchar(60) default NULL,
          `validatefield` tinyint(1) default '0',
          PRIMARY KEY  (`id`),
          UNIQUE KEY `username` (`username`)
        ) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=utf8
END
    connection connection_info
    action :nothing
  end

  mysql_database_user 'pmwiki' do
    connection connection_info
    database_name database
    password password
    action :nothing
  end
  

                
end
