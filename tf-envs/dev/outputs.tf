output "hostname" {
  value = module.umbraco-web-app.hostname  
}

output "connectionstring" {
    value   = module.sql-db.connectionstring
}