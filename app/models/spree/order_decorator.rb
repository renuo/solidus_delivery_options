Spree::Order.class_eval do
  require 'date'
  require 'spree/order/checkout'

  include SpreeDeliveryOptions::CutOffTimeParser

  validate :valid_delivery_date?
  validate :valid_delivery_time?

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

  def valid_delivery_date?
    if self.delivery_date && self.delivery_date_changed?
      self.errors[:delivery_date] << 'cannot be today or in the past' if self.delivery_date <= Date.current

      options = delivery_time_options(self.delivery_date)
      unless options && !options.empty?
        self.errors[:delivery_date] << "is not available on the selected date."
      end

      if self.delivery_date == (Date.current + 1.day) && Time.zone.now > (cutoff_time)
        self.errors[:delivery_date] << "cannot be tomorrow if the order is created after 1pm"
      end
    end

    self.errors[:delivery_date].empty? ? true : false
  end

  def delivery_time_present?
    self.errors[:delivery_time] << 'cannot be blank' unless self.delivery_time
    self.errors[:delivery_time].empty? ? true : false
  end

  def valid_delivery_time?
    return unless self.delivery_date

    self.errors[:delivery_time] << 'cannot be blank' unless self.delivery_time

    if self.delivery_time
      self.errors[:delivery_time] << 'is invalid' unless (delivery_time_options(self.delivery_date) && delivery_time_options(self.delivery_date).include?(self.delivery_time))
    end

    self.errors[:delivery_time].empty? ? true : false
  end

  private

  def delivery_time_options(date)
    date_string = date.strftime("%d/%m/%Y")
    return delivery_options[date_string] if delivery_options[date_string]

    week_day = date.strftime("%A")
    delivery_options[week_day.downcase]
  end

  def delivery_options
    @delivery_options ||= JSON.parse(SpreeDeliveryOptions::Config.delivery_time_options)
  end

end

Spree::PermittedAttributes.checkout_attributes << :delivery_date
Spree::PermittedAttributes.checkout_attributes << :delivery_time
Spree::PermittedAttributes.checkout_attributes << :delivery_instructions

Spree::Order.state_machine.before_transition :to => :payment, :do => :valid_delivery_instructions?

Spree::Order.state_machine.before_transition :to => :payment, :do => :delivery_date_present?
Spree::Order.state_machine.before_transition :to => :payment, :do => :valid_delivery_date?

Spree::Order.state_machine.before_transition :to => :payment, :do => :delivery_time_present?
Spree::Order.state_machine.before_transition :to => :payment, :do => :valid_delivery_time?

