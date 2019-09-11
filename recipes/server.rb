#
# Cookbook:: tomcat
# Recipe:: server
#
# Copyright:: 2019, The Authors, All Rights Reserved.
package 'java'

group 'tomcat' do
end

user 'tomcat' do
  group 'tomcat'
  system true
  shell '/bin/bash'
end

directory '/opt/tomcat' do
 action :create
end

remote_file '/opt/tomcat/apache-tomcat-8.0.47.tar.gz' do
  source 'http://apache.mirrors.hoobly.com/tomcat/tomcat-8/v8.0.47/bin/apache-tomcat-8.0.47.tar.gz'
  action :create
end

script 'permissions' do
  interpreter 'bash'
  cwd '/opt/tomcat'
  code <<-EOH
    sudo tar xvf apache-tomcat-8*tar.gz -C /opt/tomcat --strip-components=1
    sudo mkdir /opt/tomcat
    sudo chgrp -R tomcat /opt/tomcat/conf
    sudo chmod g+rwx /opt/tomcat/conf
    sudo chmod g+r /opt/tomcat/conf/*
    sudo chown -R tomcat /opt/tomcat/webapps/ /opt/tomcat/work/ /opt/tomcat/temp/ /opt/tomcat/logs/
    EOH
end

cookbook_file '/etc/systemd/system/tomcat.service' do
  source 'tomcat.service'
end

service 'tomcat' do
 action [:start , enabled]
end

#templates '/opt/tomcat/conf/server.xml' do
#  source 'default.rb'
#  variables(port: node['tomcat_port']
#  )
#  notifies :reload, 'service[tomcat]', :immediately
#end
