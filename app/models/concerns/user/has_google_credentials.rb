class User
  module HasGoogleCredentials
    extend ActiveSupport::Concern

    included do
      with_options if: -> { provider_uid.present? } do |user|
        user.validates_presence_of :provider_access_token
        user.validates_presence_of :provider_refresh_token
      end

      encrypts :provider_access_token
      encrypts :provider_refresh_token
    end
  end
end
