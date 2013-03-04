extend OrchWebTest

include_recipe "orch_web::nginx"

upstream_servers = [["ssl_upstream1", 8090], ["ssl_upstream2", 8091]]
upstream_servers.each do |name, port|
  configure_upstream_server(name, port)
end

app_servers = upstream_servers[0..1].map { |name, port| "localhost:#{port}" }

node.override['orch_web']['apps'] = [
  {
    'name' => 'sslapp',
    'root_path' => '/home/vagrant',
    'servers' => app_servers,
    'ssl' => {
      'key' => self_signed_ssl_key,
      'cert' => self_signed_ssl_cert
    }
  },
]

file "/home/vagrant/notes.txt" do
  owner   "vagrant"
  group   "vagrant"
  mode    "0644"
  content "This should be served up"
end

include_recipe "orch_web"
