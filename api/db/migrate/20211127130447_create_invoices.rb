class CreateFinancialInvoices < ActiveRecord::Migration[6.1]
  def change
    create_table :invoices do |t|
      t.belongs_to :user, foreign_key: true
      t.integer :number, null: false, index: true
      t.date :date, null: false, index: true
      t.text :company_data, null: false
      t.text :billing_for, null: false
      t.integer :total_value_cents, null: false
      t.string :emails, array: true, null: false, default: []

      t.timestamps

      t.index %i(user_id number), unique: true
    end
  end
end
