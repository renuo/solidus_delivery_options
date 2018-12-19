module Spree
  module OrderDecorator
    require 'date'
    require 'spree/order/checkout'

    include SolidusDeliveryOptions::DeliveryOptionsService

    validate :valid_delivery_options?

    def valid_delivery_instructions?
      if delivery_instructions && delivery_instructions.length > 500
        errors[:delivery_instructions] << 'cannot be longer than 500 charachters'
        return false
      end
      true
    end

    def delivery_date_present?
      errors[:delivery_date] << 'cannot be blank' unless delivery_date
      errors[:delivery_date].empty? ? true : false
    end

    def delivery_time_present?
      errors[:delivery_time] << 'cannot be blank' unless delivery_time
      errors[:delivery_time].empty? ? true : false
    end

    def valid_delivery_options?
      if (delivery_date && delivery_date_changed?) && (delivery_time && delivery_time_changed?)
        errors[:delivery_date] << 'cannot be today or in the past' if delivery_date <= Date.current

        options = current_delivery_options_for_date(delivery_date)
        if options.present?
          errors[:delivery_time] << 'is invalid' unless options.include?(delivery_time)
        else
          errors[:delivery_date] << 'is not available on the selected date.'
        end
      end

      errors[:delivery_date].empty? && errors[:delivery_time].empty? ? true : false
    end
  end
end

Spree::Order.prepend Spree::OrderDecorator

Spree::PermittedAttributes.checkout_attributes << :delivery_date
Spree::PermittedAttributes.checkout_attributes << :delivery_time
Spree::PermittedAttributes.checkout_attributes << :delivery_instructions

Spree::Order.state_machine.before_transition to: :payment, do: :valid_delivery_instructions?

Spree::Order.state_machine.before_transition to: :payment, do: :delivery_date_present?
Spree::Order.state_machine.before_transition to: :payment, do: :delivery_time_present?
Spree::Order.state_machine.before_transition to: :payment, do: :valid_delivery_options?
