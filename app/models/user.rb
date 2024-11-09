class User < ApplicationRecord
  include Authenticatable
  include HasGoogleCredentials

end
