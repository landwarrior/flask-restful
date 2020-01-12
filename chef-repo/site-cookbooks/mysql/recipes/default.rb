# install MySQL
remote_file "#{Chef::Config[:file_cache_path]}/mysql-community-release-el7-5.noarch.rpm" do
  source 'http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm'
  action :create
end

rpm_package 'mysql-community-release' do
  source "#{Chef::Config[:file_cache_path]}/mysql-community-release-el7-5.noarch.rpm"
  action :install
end

# ローカルからパスワードなしでログイン可能な root ユーザーだけ作成されるみたい
package 'mysql-server' do
    options '--enablerepo=mysql56-community'
    action :install
end

template '/etc/my.cnf' do
    source 'my.cnf.erb'
    owner 'root'
    group 'root'
    mode '0644'
    action :create
end

service 'mysql' do
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
