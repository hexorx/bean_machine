module Bean
  module Machine
    def self.included(base)
      base.class_eval do
        include InstanceMethods
        has_many :transfers, :as => :accountable, :class_name => 'Bean::Transfer', :order => 'id DESC'
      end
    end
    
    module InstanceMethods
      def bean
        transfers.stateful.first
      end
      
      def transfer(*args,&block)
        options = args.last.is_a?(Hash) ? args.pop : {}
        amount = args.shift.to_money
        
        options.reverse_merge!({
          :amount => amount
        })
        
        xfer = self.transfers.build(options)
        xfer.instance_eval(&block)
        xfer.save
        xfer
      end
    end      
  end
end