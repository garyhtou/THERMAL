class User
  module Authenticatable
    extend ActiveSupport::Concern

    included do
      devise :trackable,
             :omniauthable, omniauth_providers: %i[google_oauth2]

      validates :email, presence: true, uniqueness: true, format: { with: Devise.email_regexp } # case_sensitive doesn't work with encryption
      validates :provider_uid, presence: true, uniqueness: { scope: :provider }, if: -> { provider.present? }

      encrypts :email, deterministic: true, downcase: true
      encrypts :provider_uid, deterministic: true
      encrypts :current_sign_in_ip, deterministic: true
      encrypts :last_sign_in_ip, deterministic: true
    end

    class_methods do
      def from_omniauth(auth)
        find_or_create_by(provider: auth.provider, provider_uid: auth.uid) do |user|
          user.email = auth.info.email
          user.first_name = auth.info.first_name
          user.last_name = auth.info.last_name

          # TODO: user.image = auth.info.image
        end

        # TODO: save provider's oauth2 credentials
      end
    end

  end
end
