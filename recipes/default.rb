include_recipe "orch_web::nginx"

extend OrchWeb

node['orch_web']['apps'].each do |app|
  configure_app(app)
end
