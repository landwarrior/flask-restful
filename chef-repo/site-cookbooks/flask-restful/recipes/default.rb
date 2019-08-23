# ディレクトリ作成
%w[
    /var/app
    /var/app/docker
].each do |path|
    directory path do
        owner 'root'
        group 'root'
        mode '0755'
        action :create
    end
end

%w[
    yum-utils
    device-mapper-persistent-data
    lvm2
].each do |pkg|
    yum_package pkg do
        action :install
    end
end

execute 'add docker-ce.repo' do
    command "yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo"
    not_if do File.exist?("/etc/yum.repos.d/docker-ce.repo") end
end

%w[
    docker-ce
    docker-ce-cli
    containerd.io
].each do |docker|
    yum_package docker do
        options "--enablerepo=docker-ce-edge"
        action :install
    end
end

service 'docker' do
    action [:start, :enable]
end

# MySQL のインストール
remote_file "#{Chef::Config[:file_cache_path]}/mysql-community-release-el7-5.noarch.rpm" do
  source 'http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm'
  action :create
end

rpm_package 'mysql-community-release' do
  source "#{Chef::Config[:file_cache_path]}/mysql-community-release-el7-5.noarch.rpm"
  action :install
end

# ローカルならパスワードなしでログイン可能な root ユーザーだけ作成されるみたい
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
