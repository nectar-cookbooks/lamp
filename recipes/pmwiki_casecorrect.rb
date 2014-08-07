#
# Cookbook Name:: lamp
# Recipe:: pmwiki_casecorrect
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

casecorrect_url = "http://www.pmwiki.org/pmwiki/uploads/Cookbook/casecorrect.php"

case act 
when 'install', 'upgrade'
else
  raise "Unknown action #{act}"
end

if act == 'install' && ::File.exists?("#{cookbook_dir}/casecorrect.php") then
  log "CaseCorrection cookbook already installed" do
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
  
remote_file "#{cookbook_dir}/casecorrect.php" do
  source casecorrect_url
  action if act == 'install' ? :create_if_missing : :create
end

if auto then
  template "#{local_dir}/21-casecorrect.php" do
    source "casecorrect_conf.php.erb"
    action :create_if_missing
  end

  ruby_block do
    block do
      page_path = "#{pmwiki_dir}/pmwiki/wiki.d/Site.PageNotFound"
      page_file = ::File.open(page_path)
      page = page_file.read
      page_file.close
      unless /^text=.*\(:case-correction:\)/.match(page) then
        edit = Chef::Util::FileEdit(page_path)
        edit.search_file_replace(/^(text=)/, '\1(:case-correction:)')
        edit.write_file
      end
    end
  end
end
