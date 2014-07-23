node.default['lamp']['pmwiki']['version'] = 'pmwiki-latest' # any version sans the '.zip' suffix
node.default['lamp']['pmwiki']['action'] = 'install' # or 'upgrade'
node.default['lamp']['pmwiki']['config'] = 'simple' # or 'sample'
node.default['lamp']['pmwiki']['config_cookbook'] = nil

node.default['lamp']['pmwiki']['wiki_title'] = 'Default Wiki Title'
node.default['lamp']['pmwiki']['page_logo_url'] = nil
node.default['lamp']['pmwiki']['script_url'] = nil 
node.default['lamp']['pmwiki']['pub_dir_url'] = nil
node.default['lamp']['pmwiki']['admin_password'] = nil
node.default['lamp']['pmwiki']['upload_password'] = nil
node.default['lamp']['pmwiki']['enable_upload'] = false
node.default['lamp']['pmwiki']['upload_perm_add'] = 0
node.default['lamp']['pmwiki']['enable_diag'] = false
node.default['lamp']['pmwiki']['enable_ims_caching'] = false
node.default['lamp']['pmwiki']['enable_creole'] = false
node.default['lamp']['pmwiki']['enable_wikiwords'] = false
node.default['lamp']['pmwiki']['space_wikiwords'] = false
node.default['lamp']['pmwiki']['tz'] = nil
node.default['lamp']['pmwiki']['blocklist'] = nil # e.g. 1 or 10 -
                                                  # see PmWiki.Blocklist
node.default['lamp']['pmwiki']['ws_pre'] = 0
node.default['lamp']['pmwiki']['diff_keep_days'] = nil
node.default['lamp']['pmwiki']['enable_page_list_protect'] = true
node.default['lamp']['pmwiki']['skin'] = nil
