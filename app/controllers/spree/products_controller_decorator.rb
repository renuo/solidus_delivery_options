module Spree
  module ProductsControllerDecorator
    helper 'solidus_delivery_options/base'
  end
end

Spree::ProductsController.prepend Spree::ProductsControllerDecorator
