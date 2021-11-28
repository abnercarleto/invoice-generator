class RemoveEmailsFromInvoices < ActiveRecord::Migration[6.1]
  def change
    remove_column(:invoices, :emails, :string, default: [], null: false, array: true)
  end
end
