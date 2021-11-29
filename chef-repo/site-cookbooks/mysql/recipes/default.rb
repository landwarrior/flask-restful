# install MySQL
package 'mysql-server' do
    action :install
end

template '/etc/my.cnf.d/mysql-server.cnf' do
    source 'mysql-server.cnf.erb'
    owner 'root'
    group 'root'
    mode '0644'
    action :create
end

template '/etc/my.cnf.d/client.cnf' do
    source 'client.cnf.erb'
    owner 'root'
    group 'root'
    mode '0644'
    action :create
end

service 'mysqld' do
  action [:enable, :start]
end

# set up MySQL
execute 'create database if not exists mydb' do
    command 'mysql -uroot -e"create database if not exists mydb default charset=utf8"'
end
cookbook_file "/#{Chef::Config[:file_cache_path]}/init.sql" do
    source 'init.sql'
    mode 0644
    owner 'root'
    group 'root'
    action :create
end
execute 'initializing mydb' do
    command "mysql -uroot -Dmydb < #{Chef::Config[:file_cache_path]}/init.sql"
end
