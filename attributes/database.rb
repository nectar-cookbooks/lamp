node.default['lamp']['adodb']['version'] = '519'
node.default['lamp']['adodb']['default_password'] = nil
node.default['lamp']['adodb']['databases'] = {
  'myUserDatabase' => {
    'driver' => 'mysql',
    'hostname' => 'localhost',
    'database' => 'pmwikiDatabase',
    'username' => 'pmwikiUser',
    'password' => nil
  }
}                                           
node.default['lamp']['adodb']['root_password'] = nil
