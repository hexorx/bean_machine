ActiveRecord::Migration.verbose = false

ActiveRecord::Schema.define do
  create_table :users, :force => true do |t|
  end
  
  create_table :billing_transactions, :force => true do |t|
    t.references :user
    t.integer :amount
    t.string :debit
    t.string :credit
    t.string :currency, :null => false, :default => 'USD'
    t.string :action
    t.boolean :success
    t.string :reference
    t.string :message
    t.text :params
    t.boolean :test
  end
end