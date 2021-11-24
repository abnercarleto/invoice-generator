class User < ApplicationRecord
  has_secure_token :token

  validates :email, format: { with: %r{\A(.+)@(.+)\z}, message: 'Email invalid' },
                    uniqueness: { case_sensitive: false },
                    length: { minimum: 4, maximum: 254 }
end
