class User
  module HasGoogleCredentials
    extend ActiveSupport::Concern

    included do
      validates_presence_of :provider_refresh_token, if: -> { provider_uid.present? }

      encrypts :provider_refresh_token
    end
  end
end
