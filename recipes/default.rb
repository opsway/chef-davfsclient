package "davfs2" do
  action :install
end

directory "/etc/davfs2/"

template "/etc/davfs2/davfs2.conf" do
  source "davfs2.conf.erb"
  mode   "0644"
  owner  "root"
  group  "root"
end

template "/etc/davfs2/secrets" do
    source "secrets.erb"
    mode   "0600"
    owner  "root"
    group  "root"
    variables(:dirs => node[:davfsclient][:mounts])
end

(node[:davfsclient][:mounts]).each do |dirname,dirattr|
  if not File.directory?(dirattr[:local])
    directory "#{dirattr[:local]}" do
      action :create
      recursive true
    end
  end

  mount_options = []
  # allow another user to own the mount
  if dirattr[:uid]
    mount_options << "uid=#{dirattr[:uid]}"
  end
  if dirattr[:gid]
    mount_options << "gid=#{dirattr[:gid]}"
  end
  mount_options << "defaults"
  mount_options << "_netdev"

  mount "#{dirattr[:local]}" do
    not_if "grep -e \"#{dirattr[:local]}\" /proc/mounts"
    device "#{dirattr[:remote]}"
    fstype "davfs" 
    action [:mount, :enable]  
    options mount_options.join(",")
    dump 0
    pass 0
    retries 5
    retry_delay 20
  end
end

template "/etc/init.d/davfsclient" do
    source "davfsclient.erb"
    mode   "0755"
    owner  "root"
    group  "root"
    variables(:dirs => node[:davfsclient][:mounts])
end

if not File.exists?("/etc/rc3.d/S20davfsclient")
    execute "create-startup-scripts" do
        command "update-rc.d -f davfsclient defaults"
    end
end

service "davfsclient" do
  pattern "davfsclient"
  action [:enable]
end
