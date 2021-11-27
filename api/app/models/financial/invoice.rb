module Financial
  class Invoice < ApplicationRecord
    belongs_to :user, class_name: 'Identity::User', inverse_of: :invoices

    validates :number, :date, :company_data, :billing_for, :total_value_cents,
              presence: true
    validates :number, uniqueness: { scope: :user_id }
  end
end
