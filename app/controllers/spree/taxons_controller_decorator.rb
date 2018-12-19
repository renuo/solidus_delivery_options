module Spree
  module TaxonsControllerDecorator
    helper 'solidus_delivery_options/base'
  end
end

Spree::TaxonsController.prepend Spree::TaxonsControllerDecorator
