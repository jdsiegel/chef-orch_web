extend WubTest

include_recipe "chef-wub::nginx"

upstream_servers = [["upstream1", 8080], ["upstream2", 8081], ["upstream3", 8082], ["upstream4", 8083]]
upstream_servers.each do |name, port|
  configure_upstream_server(name, port)
end

app1_servers = upstream_servers[0..1].map { |name, port| "localhost:#{port}" }
app2_servers = upstream_servers[2..3].map { |name, port| "localhost:#{port}" }

node.override['wub']['apps'] = [
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

include_recipe "chef-wub"
