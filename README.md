Overview
========

This cookbook contains recipes for installing and configuring various 
LAMP-based web services.

This is all "under development" ... as indicated by the version number.

Prerequisites:
--------------

You typically need to open firewall access on ports 80 and 443.  (If you 
use non-standard ports, adjust accordingly.)  

For a NeCTAR virtual, you need to open the external firewall ports using
the NeCTAR Dashboard:
 1. Go to your project's "Access & Security" panel
 2. Click "Edit Rules".
 3. Click "Add Rule", fill in the port and then "Add".  
 4. Repeat for each port you need to open.

For security reasons, you should not open the database ports.

Recipes:
--------

The `default` recipe installs and minimally configures an Apache HTTPD service
with the "default" Apache site enabled and PHP5.

The `database` recipe installs MySQL and configures the service, and creates
the "root" account.

Attributes:
----------

 * `node['lamp']['database']['root_password']` - This should be set to the 
   password for your database's "root" account.  The "lamp::database" insists
   that you set this attribute.

 * `node['lamp']['database']['host']` - This is the hostname used to connect 
   to the database.  It defaults to "localhost".


TODO List:
----------

 * Support for other web servers and other database services.
 
 * Implement some internal firewalling.

 * Support creation of "service" databases and database accounts.

 * Support for configuring SSL / HTTPS.
