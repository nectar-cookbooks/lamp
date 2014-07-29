node.default['lamp']['pmwiki']['version'] = 'pmwiki-latest' # any version sans the '.zip' suffix
node.default['lamp']['pmwiki']['action'] = 'install' # or 'upgrade'
node.default['lamp']['pmwiki']['config'] = 'simple' # or 'sample'
node.default['lamp']['pmwiki']['auto_config'] = false
node.default['lamp']['pmwiki']['config_cookbook'] = nil

node.default['lamp']['pmwiki']['wiki_title'] = 'Default Wiki Title'
node.default['lamp']['pmwiki']['page_logo_url'] = nil
node.default['lamp']['pmwiki']['script_url'] = nil 
node.default['lamp']['pmwiki']['pub_dir_url'] = nil

# The password attributes should be set to hashes that are compatible
# with the PHP 'crypt' function.  If the password attributes are not 
# set, we use an annoyingly long and hard to type passwords ... to 
# encourage the you to do the right thing and set the password. 
node.default['lamp']['pmwiki']['admin_password'] = nil
node.default['lamp']['pmwiki']['upload_password'] = nil

node.default['lamp']['pmwiki']['enable_upload'] = false
node.default['lamp']['pmwiki']['upload_perm_add'] = 0
node.default['lamp']['pmwiki']['enable_path_info'] = false
node.default['lamp']['pmwiki']['enable_diag'] = false
node.default['lamp']['pmwiki']['enable_ims_caching'] = false
node.default['lamp']['pmwiki']['enable_creole'] = false
node.default['lamp']['pmwiki']['enable_wikiwords'] = false
node.default['lamp']['pmwiki']['space_wikiwords'] = false
node.default['lamp']['pmwiki']['tz'] = 'UTC'      # This must be set ...
node.default['lamp']['pmwiki']['blocklist'] = nil # e.g. 1 or 10 -
                                                  # see PmWiki.Blocklist
node.default['lamp']['pmwiki']['ws_pre'] = 0
node.default['lamp']['pmwiki']['diff_keep_days'] = nil
node.default['lamp']['pmwiki']['enable_page_list_protect'] = true
node.default['lamp']['pmwiki']['enable_refcount'] = false
node.default['lamp']['pmwiki']['enable_atom_feed'] = false # Atom 1.0
node.default['lamp']['pmwiki']['enable_rss_feed'] = false  # RSS 2.0
node.default['lamp']['pmwiki']['enable_dc_feed'] = false   # Dublin Core
node.default['lamp']['pmwiki']['enable_rdf_feed'] = false  # RSS 1.0
node.default['lamp']['pmwiki']['enable_relative_page_vars'] = false
node.default['lamp']['pmwiki']['enable_autocreate_categories'] = false
node.default['lamp']['pmwiki']['skin'] = nil
