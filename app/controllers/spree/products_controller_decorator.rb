module Spree
  module ProductsControllerDecorator
    class << self
      def prepended(klass)
        klass.helper 'solidus_delivery_options/base'
      end
    end
  end
end

Spree::ProductsController.prepend Spree::ProductsControllerDecorator
