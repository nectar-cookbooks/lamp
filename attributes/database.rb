node.default['lamp']['adodb']['version'] = '519'
node.default['lamp']['adodb']['default_password'] = nil
node.default['lamp']['adodb']['databases'] = {}

# Example 'databases' hash.  Note that other recipes may add their own
# entries to the attribute on the fly.
# { 
#   'myUserDatabase' => {
#     'driver' => 'mysqli',
#     'hostname' => 'localhost',
#     'database' => 'pmwikiDatabase',
#     'username' => 'pmwikiUser',
#     'password' => nil
#   }
# }                                           

node.default['lamp']['database']['root_password'] = nil
node.default['lamp']['database']['host'] = 'localhost'
