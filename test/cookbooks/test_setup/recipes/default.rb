extend OrchWebTest

include_recipe "orch_web::nginx"

upstream_servers = [["upstream1", 8080], ["upstream2", 8081], ["upstream3", 8082], ["upstream4", 8083]]
upstream_servers.each do |name, port|
  configure_upstream_server(name, port)
end

app1_servers = upstream_servers[0..1].map { |name, port| "localhost:#{port}" }
app2_servers = upstream_servers[2..3].map { |name, port| "localhost:#{port}" }

node.override['orch_web']['apps'] = [
  {
    'name' => 'app1',
    'root_path' => '/home/vagrant',
    'servers' => app1_servers
  },
  {
    'name' => 'app2',
    'root_path' => '/home/vagrant',
    'port' => 81,
    'servers' => app2_servers
  }
]

file "/home/vagrant/notes.txt" do
  owner   "vagrant"
  group   "vagrant"
  mode    "0644"
  content "This should be served up"
end

include_recipe "orch_web"
