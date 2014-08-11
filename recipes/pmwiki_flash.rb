#
# Cookbook Name:: lamp
# Recipe:: pmwiki_flash
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
act = node['lamp']['pmwiki']['action']
auto = node['lamp']['pmwiki']['auto_config']
script = node['lamp']['pmwiki']['flash_script'] || 'swf.php'


flash_url = "http://www.pmwiki.org/pmwiki/uploads/Cookbook/#{script}"

case act 
when 'install', 'upgrade'
else
  raise "Unknown action #{act}"
end

case script
when 'flash.php', 'flash2.php'
  description = "Uses #{script}: supports '(:flash ... :) markup"
when 'swf.php'
  description = "Uses #{script}: supports links ending with '.swf'"
else
  raise "Unknown flash script #{script}"
end

if act == 'install' && ::File.exists?("#{cookbook_dir}/#{script}") then
  log "Flash cookbook (#{script}) already installed" do
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
    source flash_url
    action if act == 'install' ? :create_if_missing : :create
  end
  
  if auto then
    template "#{local_dir}/24-flash.php" do
      source "flash_conf.php.erb"
      variables ({ :Flash_Script => script,
                   :Flash_Description => description })
      action :create_if_missing
    end
  end
end
