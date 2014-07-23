node.default['lamp']['pmwiki']['version'] = 'pmwiki-latest' # any version sans the '.zip' suffix
node.default['lamp']['pmwiki']['action'] = 'install' # or 'upgrade'

node.default['lamp']['pmwiki']['wiki_title'] = 'Default Wiki Title'
node.default['lamp']['pmwiki']['page_logo_url'] = nil
node.default['lamp']['pmwiki']['script_url'] = nil 
node.default['lamp']['pmwiki']['pub_dir_url'] = nil
node.default['lamp']['pmwiki']['admin_password'] = nil
node.default['lamp']['pmwiki']['upload_password'] = nil
node.default['lamp']['pmwiki']['enable_upload'] = false
node.default['lamp']['pmwiki']['tz'] = nil
