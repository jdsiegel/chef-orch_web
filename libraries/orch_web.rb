module OrchWeb
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

    if app['ssl']
      ssl = app['ssl']
      ssl_key  = ssl['key']
      ssl_cert = ssl['cert']

      raise "App '#{name}' requires ssl key"  unless ssl_key
      raise "App '#{name}' requires ssl cert" unless ssl_cert

      ssl_port      = ssl['port'] || 443
      ssl_name      = "#{name}_ssl"
      ssl_dir       = "#{node['nginx']['dir']}/ssl"
      ssl_key_file  = "#{ssl_dir}/#{name}.key"
      ssl_cert_file = "#{ssl_dir}/#{name}.cert"

      directory ssl_dir do
        owner "root"
        mode  "0755"
      end

      file ssl_key_file do
        owner   "root"
        mode    "0644"
        content ssl_key

        notifies     :reload, "service[nginx]"
      end

      file ssl_cert_file do
        owner   "root"
        mode    "0644"
        content ssl_cert

        notifies     :reload, "service[nginx]"
      end

      template "#{node['nginx']['dir']}/sites-available/#{ssl_name}" do
        source       "nginx_vhost.erb"
        owner        "root"
        mode         "0644"
        variables({
          name:      ssl_name,
          servers:   servers,
          hostname:  hostname,
          port:      ssl_port,
          root_path: root_path,
          log_path:  log_path,
          ssl_key:   ssl_key_file,
          ssl_cert:  ssl_cert_file
        })

        notifies     :reload, "service[nginx]"
      end

      nginx_site "#{ssl_name}"
    end
  end
end
