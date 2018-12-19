module SolidusDeliveryOptions
  module ApplicationHelperDecorator
    include SolidusDeliveryOptions::BaseHelper
  end
end

ApplicationHelper.prepend SolidusDeliveryOptions::ApplicationHelperDecorator
