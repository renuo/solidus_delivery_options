Deface::Override.new(virtual_path: 'spree/shared/_order_details',
                     name: 'add_delivery_date_details_to_order',
                     insert_after: "[data-hook='order-shipment'] .delivery",
                     partial: 'spree/orders/order_delivery_date_details',
                     disabled: false)
