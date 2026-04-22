terraform { 
  cloud { 
    organization = "greed-island" 

    workspaces { 
      name = "sentinel-x-sentinel" 
    } 
  }
  required_providers {
    restapi = {
      source = "mastercard/restapi"
    }
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
    azapi = {
      source = "azure/azapi"
    }
    github = {
      source = "integrations/github"
    }
    incident_io = {
      source = "incident-io/incident-io"
    }
    grafana = {
      source = "grafana/grafana"
    }
    auth0 = {
      source = "auth0/auth0"
    }
    modtm = {
      source = "azure/modtm"
    }
    clickhouse = {
      source = "ClickHouse/clickhouse"
    }
  } 
}
