#
# Cookbook Name:: lamp
# Recipe:: pmwiki_database_standard
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

## We just install the PHP5 ADOdb code and the "connect" file in the
## Cookbook directory.  It is up to the config template (or whatever) 
## to include the connect and set the database configuration params. 

pmwiki_dir = node['apache']['docroot_dir']
cookbook_dir = "#{pmwiki_dir}/pmwiki/cookbook"
local_dir = "#{pmwiki_dir}/pmwiki/local"
version = node['lamp']['adodb']['version']
act = node['lamp']['pmwiki']['action']
auto = node['lamp']['pmwiki']['config'] == 'auto'

adodb_url = "http://sourceforge.net/projects/adodb/files/adodb-php5-only/adodb-#{version}-for-php5/adodb#{version}.zip"
connect_url = 'http://www.pmwiki.org/pmwiki/uploads/Cookbook/adodb-connect.php'
zip_path = "/opt/pmwiki/adodb#{version}.zip"

case act 
when 'install', 'upgrade'
else
  raise "Unknown action #{act}"
end

if act == 'install' && ::File.exists?("#{cookbook_dir}/adodb") then
  log "ADOdb already installed" do
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

  package 'unzip' do
    action :install
  end
  
  directory '/opt/pmwiki' do
    recursive true
  end
  
  remote_file zip_path do
    source adodb_url
    action :create_if_missing
  end
  
  bash "#{act} pmwiki/cookbook/adodb" do
    code lazy { <<-EOF
    cd #{cookbook_dir}
    rm -rf adodb
    unzip #{zip_path}
    mv adodb5 adodb
EOF
    }
    user node['apache']['user']
  end
end

remote_file "#{cookbook_dir}/adodb-connect.php" do
  source connect_url
  action if act == 'install' ? :create_if_missing : :create
end

if auto then
  template "#{local_dir}/10-adodb.php" do
    source "adodb_conf.php.erb"
    action :create_if_missing
  end
end
