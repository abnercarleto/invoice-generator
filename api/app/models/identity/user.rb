module Identity
  class User < ApplicationRecord
    has_secure_token :token

    has_many :invoices, class_name: 'Financial::Invoice', inverse_of: :user

    validates :email, format: { with: %r{\A(.+)@(.+)\z} },
                      uniqueness: { case_sensitive: false },
                      length: { minimum: 4, maximum: 254 }
  end
end
