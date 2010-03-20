## Bean Machine

Accounting sucks. Well if you are trying to do it right it does. Bean machine gives you the power of an immutable double entry accounting system through the use of a simple transfer method. The idea is to make accounting easy by breaking it into easy to follow steps. Transfer this much from this account to that account.

### Current Status

Bean Machine is very rough right now. The basics work but you will need to do some manual work setting up the db and such. It will change and it will break. But that just means it is an active project and will make rapid progress. Until it gets a couple good point releases you probably shouldn't use it in production. I probably will be using it in production to help figure out the best way to take it but you shouldn't. Just don't.

### Installation

Bean Machine is hosted on GemCutter ... I mean RubyGems, So just install like a normal gem.

    sudo gem install bean_machine --pre
    
### Schema

Until nice generators are done you can manually make a migration with the following structure. It will change frequently while the kinks are getting worked out.

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
    
### Overview

Bean Machine is based on the double entry accounting system. Every transfer is moving money from one account to another account. Eventually I will give a nice tutorial on basic accounting principles but it will have to wait.
    
### Usage

An example is worth a thousand words so lets do a quick one.

    class User < ActiveRecord::Base
      # tell it who has the balances
      include Bean::User
      
      has_many :invoices
    end
      
    class Invoice < ActiveRecord::Base
      # this adds the transfer method
      include Bean::Machine
      
      belongs_to :user
      
      # just transfer an amount from a credit account to a debit account.
      # it doesn't really matter what account you credit and what you
      # debit as long as you keep it consistant.
      def pay(amount)
        transfer amount.to_money, :credit => :payments, :debit => :invoice
      end
    end
    
    # just make a user
    @user = User.create
    
    # give them a couple invoices
    @invoice = @user.invoices.create
    
    # pay some amount on the invoice
    @invoice.pay(10)
    
    # lookup the balance for a given account
    @user.balance(:invoice) #=> Money object with value of 1000 cents
    @user.balance(:invoice).to_s #=> '10.00'

    # pay more on the invoice
    @invoice.pay(20)
    
    # and the balance increases
    @user.balance(:invoice).to_s #=> '30.00' 
    @user.balance(:payments).to_s #=> '30.00' 

    
This example has not been tested yet but is here to give you a basic idea of how it works.
    
    
### ToDo

- Lots and lots
- Mixins for common accounting transactions (payment, invoice, etc)
- Integrate ActiveMerchant
- Pluggable transfer store (noSQL)
- ORM independent

## Note on Patches/Pull Requests
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but
   bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Sponsored By

This gem is sponsored by [Teliax][]. [Teliax][] makes business class Voice, [Centrex][](Including Hosted: IVRs, Ring Groups, Extensions and Day Night Mode) and Data services accessible to anyone. You don't have to be a fortune 500 to sound big!

## Copyright

Copyright (c) 2010 Josh Robinson . See LICENSE for details.