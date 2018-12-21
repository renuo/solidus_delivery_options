module Spree
  module TaxonsControllerDecorator
    class << self
      def prepended(klass)
        klass.helper 'solidus_delivery_options/base'
      end
    end
  end
end

Spree::TaxonsController.prepend Spree::TaxonsControllerDecorator
