ActiveRecord::Migration.verbose = false

ActiveRecord::Schema.define do
  create_table :users, :force => true do |t|
  end
  
  create_table :payments, :force =>  true do |t|
    t.integer :amount
    t.string :currency, :null => false, :default => 'USD'
    t.string :reference
  end
  
  create_table :bean_transfers, :force => true do |t|
    t.references :user
    t.references :accountable, :polymorphic => true
    
    t.string :state
    t.integer :amount
    t.string :debit
    t.string :credit
    t.string :currency, :null => false, :default => 'USD'
    t.string :event, :null => false, :default => 'transfer'
    t.boolean :success
    t.string :reference
    t.string :message
    t.text :params
    t.boolean :test
    t.boolean :affect_balance
  end
end