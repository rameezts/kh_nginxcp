#!/bin/bash
# NginxCP Admin Auto-Installer for KnownHost.com server's only!
CURIP=`/sbin/ifconfig | awk '/^eth/ { printf("%s\t",$1) } /inet addr:/ { gsub(/.*:/,"",$2); if ($2 !~ /^127/) print $2; }' |head -n1`

echo "Beginning KnownHost's NginxCP Auto Installer..."
echo "Downloading source package..."
  curl -so /usr/local/src/kh_nginxadmin.tar http://nginxcp.com/latest/nginxadmin.tar
echo "Extracting and begginging install... (Be patient)"
  tar -xf /usr/local/src/kh_nginxadmin.tar -C /usr/local/src/
    if [ ! -d "/var/cpanel/apps" ]; then
      mkdir -p /var/cpanel/apps
    fi
  cd /usr/local/src/publicnginx
    ./nginxinstaller install
echo "Installation completed..."
echo "Restarting httpd automatically..."
  /etc/init.d/httpd restart  
echo "Nginx restarted..."
echo "Nginx is listening:"
  netstat -tulpn |grep nginx
echo "Registering the plugin with WHM..."
  /usr/local/cpanel/bin/register_appconfig /var/cpanel/apps/nginxcp.conf
echo " "
echo "Installed! To access the Control Panel for nginx, visit:"
echo "WHM Panel ( https://$CURIP:2087 ) >> Plugins >> nginx Admin."
echo " "
echo "Creating automated temp files cleanup..."
  echo "0 */1 * * * /usr/sbin/tmpwatch -am 1 /tmp/nginx_client" >> /var/spool/cron/root
  /etc/init.d/crond restart
echo "Completed! - Thank you for choosing www.knownhost.com"
