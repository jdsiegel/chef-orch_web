module WubTest
  def configure_upstream_server(name, port)
    template "#{node['nginx']['dir']}/sites-available/#{name}" do
      source       "upstream_vhost.erb"
      owner        "root"
      mode         "0644"
      variables({
        port: port,
        root_path: "#{node['nginx']['source']['prefix']}/html"
      })

      notifies     :reload, "service[nginx]"
    end

    nginx_site name
  end
end
