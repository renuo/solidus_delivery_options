module Spree
  module CheckoutControllerDecorator
    class << self
      def prepended(klass)
        klass.helper 'solidus_delivery_options/base'
      end
    end
  end
end

Spree::CheckoutController.prepend Spree::CheckoutControllerDecorator
