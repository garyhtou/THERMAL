class User
  module Authenticatable
    extend ActiveSupport::Concern

    included do
      devise :trackable,
             :omniauthable, omniauth_providers: %i[google_oauth2]

      validates :email, presence: true, uniqueness: true
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
