#
# Cookbook Name:: lamp
# Recipe:: pmwiki
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

include_recipe 'lamp::base'

# In the first instance, just drop pmwiki into "a location accessible
# by the webserver" ... like the installation instructions say.  Maybe
# we ought to explicitly drop it into the CGI bin directory.

pmwiki_dir = node['apache']['docroot_dir']

package 'unzip' do
  action :install
end

version = node['lamp']['pmwiki']['version'] 
zip_path = "/opt/pmwiki/#{version}.zip"

directory '/opt/pmwiki' do
  recursive true
end

remote_file zip_path do
  source "http://pmwiki.org/pub/pmwiki/#{version}.zip"
  action :create_if_missing 
end

# (Only necessary if #{pmwiki_dir} is a non-standard place ...)
directory pmwiki_dir do
  owner node['apache']['user']
end

# Figure out the real 
ruby_block 'extract pmwiki version' do
  block do
    Chef::Resource::RubyBlock.send(:include, Chef::Mixin::ShellOut)

    raise "Can't find the ZIP file" unless ::File.exists?(zip_path)
    p = shell_out!("unzip -Z -1 #{zip_path} | head -n 1")
    real_version = %r{^[^/]+}.match(p.stdout)[0]
    raise "real_version is #{real_version}"
    node.override['lamp']['pmwiki']['real_version'] = real_version
  end
  notifies :run, 'bash[unzip pmwiki]', :immediate
end

bash "unzip pmwiki" do
  code "unzip #{zip_path}"
  user node['apache']['user']
  cwd pmwiki_dir
  action :nothing
  notifies :run, "link[#{pmwiki_dir}/pmwiki]", :immediate
end

link "#{pmwiki_dir}/pmwiki" do
  to lazy { "#{pmwiki_dir}/#{node['lamp']['pmwiki']['real_version']}" }
  owner node['apache']['user']
  action :nothing
end


apache_site 'default' do
  enable true
end

