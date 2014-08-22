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

Recipes:
--------

The `default` recipe installs and minimally configures
an Apache HTTPD service.

The `database` recipe installs MySQL and configures a service
