module Wub
  def configure_app(app)
    name      = app['name']
    servers   = app['servers']           || []
    hostname  = app['hostname']          || "_"
    port      = app['port']              || 80
    root_path = app['root_path']
    log_path  = node['nginx']['log_dir']

    raise "App requires a name" unless name
    raise "App '#{name}' requires a root path" unless root_path
    raise "App '#{name}' has an empty server list" if servers.empty?

    servers = servers.split if servers.respond_to?(:split)

    template "#{node['nginx']['dir']}/sites-available/#{name}" do
      source       "nginx_vhost.erb"
      owner        "root"
      mode         "0644"
      variables({
        name:      name,
        servers:   servers,
        hostname:  hostname,
        port:      port,
        root_path: root_path,
        log_path:  log_path
      })

      # doesn't work with nginx via runit. runit definition does not enable "reload" action
      notifies     :reload, "service[nginx]"

      #notifies     :restart, "service[nginx]"
    end

    nginx_site "#{name}"
  end
end
