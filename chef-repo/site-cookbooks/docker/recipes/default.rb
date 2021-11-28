# install docker-ce
%w[
    yum-utils
    device-mapper-persistent-data
    lvm2
].each do |pkg|
    dnf_package pkg do
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
    dnf_package docker do
        options "--enablerepo=docker-ce-stable"
        action :install
    end
end

service 'docker' do
    action [:start, :enable]
end

# create directory
%w[
    /var/app
    /var/app/docker
    /var/app/docker/flask
    /var/app/docker/nginx
].each do |path|
    directory path do
        owner 'root'
        group 'root'
        mode '0755'
        action :create
    end
end


template '/var/app/docker/nginx/nginx.conf' do
    source 'nginx.conf.erb'
    owner 'root'
    group 'root'
    mode '0644'
    action :create
end
