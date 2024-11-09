class User
  module HasGoogleCredentials
    extend ActiveSupport::Concern

    TOKEN_CREDENTIAL_URI = "https://oauth2.googleapis.com/token".freeze

    included do
      validates_presence_of :provider_refresh_token, if: -> { provider_uid.present? }
      encrypts :provider_refresh_token
    end

    def google_credentials
      # I'm only using Signet to serve as the authentication object for Google::Apis::DriveV3::DriveService
      # Signet handles refreshing the access token — in fact, I'm not storing the access token at all.
      @google_credentials ||= Signet::OAuth2::Client.new(
        token_credential_uri: TOKEN_CREDENTIAL_URI,
        client_id: Rails.application.credentials.dig(:google, :oauth_client_id),
        client_secret: Rails.application.credentials.dig(:google, :oauth_client_secret),
        refresh_token: provider_refresh_token,
      )
    end
  end
end
