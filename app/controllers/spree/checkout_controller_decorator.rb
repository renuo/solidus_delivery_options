module Spree
  module CheckoutControllerDecorator
    helper 'solidus_delivery_options/base'
  end
end

Spree::CheckoutController.prepend Spree::CheckoutControllerDecorator
