
variable "iam_clients" {
  
  type = map(object({
    name          = string
    type          = string
    is_hybrid     = bool
    client_id     = string        # Explicit ID for PingFederate/PingOne
    secret        = string        # Sensitive: Use a Vault/Secret Manager later!
    grant_types   = list(string)
    redirect_uris = list(string)
    oauth_scopes  = list(string)
    description = string
  }))

  default = {
    # 1. HYBRID WEB APP (Goes to P1 and PingFed)
    "uk-web-portal" = {
      name          = "UK-Web-Portal"
      type          = "WEB_APP"
      is_hybrid     = true
      client_id     = "uk_web_portal_001"
      secret        = "placeholder-secret-1" # We will secure this in Phase 3
      grant_types   = ["AUTHORIZATION_CODE", "REFRESH_TOKEN"]
      redirect_uris = ["https://portal.uk.example.com/callback"]
      oauth_scopes  = ["openid", "profile", "email"]
      description = "Client for the UK Web Portal application, which serves as the main interface for users to access their accounts and services."
    },

    # 2. CLOUD-ONLY WORKER (Goes to P1 only)
    "uk-chatbot-prod" = {
      name          = "UK-Chatbot-Prod"
      type          = "WORKER"
      is_hybrid     = false
      client_id     = "uk_chatbot_svc"
      secret        = "placeholder-secret-2"
      grant_types   = ["CLIENT_CREDENTIALS"]
      redirect_uris = [] # Workers don't need redirects
      oauth_scopes  = ["p1:read:user"]
      description = "Client for the UK Chatbot application, which provides automated customer support services."

    },

    # 3. HYBRID MOBILE/SPA (To test your logic)
    "uk-mobile-ios" = {
      name          = "UK-Mobile-iOS"
      type          = "WEB_APP" # Mobile uses OIDC logic
      is_hybrid     = true
      client_id     = "uk_ios_app"
      secret        = "placeholder-secret-3"
      grant_types   = ["AUTHORIZATION_CODE"]
      redirect_uris = ["com.example.uk://oauth/callback"]
      oauth_scopes  = ["openid", "profile", "offline_access"]
      description = "Client for the UK Mobile iOS application, which allows users to manage their accounts on their mobile devices."
    }
  }

  # POLICY 1: Restricitions on Client Types 
  validation {
    condition = alltrue([
      for client in var.iam_clients :
      contains(["WORKER", "WEB_APP"], client.type)
    ])
    error_message = "iam_clients.type must be WORKER or WEB_APP for every client"
  }

}