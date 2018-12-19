Spree::Core::Engine.routes.draw do
  get 'admin/orders/:order_id/delivery_options/', controller: 'admin/orders/delivery_options', action: 'edit', as: 'admin_order_delivery_options'
  patch 'admin/orders/:order_id/delivery_options/', controller: 'admin/orders/delivery_options', action: 'update'
end
