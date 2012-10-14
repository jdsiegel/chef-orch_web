include_recipe "chef-wub::nginx"

extend Wub

node['wub']['apps'].each do |app|
  configure_app(app)
end
