Spree::Order.class_eval do
  require 'date'
  require 'spree/order/checkout'

  include SpreeDeliveryOptions::DeliveryOptionsService

  validate :valid_delivery_options?

  def valid_delivery_instructions?
    if self.delivery_instructions && self.delivery_instructions.length > 500
      self.errors[:delivery_instructions] << 'cannot be longer than 500 charachters'
      return false
    end
    true
  end

  def delivery_date_present?
    self.errors[:delivery_date] << 'cannot be blank' unless self.delivery_date
    self.errors[:delivery_date].empty? ? true : false
  end

  def delivery_time_present?
    self.errors[:delivery_time] << 'cannot be blank' unless self.delivery_time
    self.errors[:delivery_time].empty? ? true : false
  end

  def valid_delivery_options?
    if (self.delivery_date && self.delivery_date_changed?) && (self.delivery_time && self.delivery_time_changed?)
      self.errors[:delivery_date] << 'cannot be today or in the past' if self.delivery_date <= Date.current

      options = current_delivery_options_for_date(self.delivery_date)
      if options
        self.errors[:delivery_time] << 'is invalid' unless options.include?(self.delivery_time)
      else
        self.errors[:delivery_date] << "is not available on the selected date."
      end
    end

    (self.errors[:delivery_date].empty? && self.errors[:delivery_time].empty?) ? true : false
  end

end

Spree::PermittedAttributes.checkout_attributes << :delivery_date
Spree::PermittedAttributes.checkout_attributes << :delivery_time
Spree::PermittedAttributes.checkout_attributes << :delivery_instructions

Spree::Order.state_machine.before_transition :to => :payment, :do => :valid_delivery_instructions?

Spree::Order.state_machine.before_transition :to => :payment, :do => :delivery_date_present?
Spree::Order.state_machine.before_transition :to => :payment, :do => :delivery_time_present?
Spree::Order.state_machine.before_transition :to => :payment, :do => :valid_delivery_options?
