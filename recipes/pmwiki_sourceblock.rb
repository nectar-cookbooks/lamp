#
# Cookbook Name:: lamp
# Recipe:: pmwiki_sourceblock
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
version = node['lamp']['geshi']['version']
cookbook_dir = "#{pmwiki_dir}/pmwiki/cookbook"
local_dir = "#{pmwiki_dir}/pmwiki/local"
act = node['lamp']['pmwiki']['action']
auto = node['lamp']['pmwiki']['auto_config']
script = 'sourceblock.php'
zip_path = "#{Chef::Config['file_cache_path']}/GeSHi-#{version}.zip"

# TODO - change this so that we can support 'latest'
geshi_url = "http://sourceforge.net/projects/geshi/files/geshi/GeSHi%20#{version}/GeSHi-#{version}.zip"

script_url = "http://www.pmwiki.org/pmwiki/uploads/Cookbook/#{script}"

case act 
when 'install', 'upgrade'
else
  raise "Unknown action #{act}"
end

if act == 'install' && ::File.exists?("#{cookbook_dir}/#{script}") then
  log "Sourceblock cookbook (#{script}) already installed" do
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

  remote_file "#{cookbook_dir}/#{script}" do
    source script_url
    action if act == 'install' ? :create_if_missing : :create
  end

  remote_file zip_path do 
    source geshi_url
  end
  
  bash "#{act} pmwiki/cookbook/adodb" do
    code lazy { <<-EOF
    cd #{cookbook_dir}
    rm -rf geshi
    unzip #{zip_path}
EOF
    }
    user node['apache']['user']
  end

  if auto then
    template "#{local_dir}/25-sourceblock.php" do
      source "sourceblock_conf.php.erb"
      action :create_if_missing
    end
  end
end
