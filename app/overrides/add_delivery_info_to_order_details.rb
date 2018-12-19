Deface::Override.new(virtual_path: 'spree/admin/orders/_form',
                     name: 'add_delivery_info_to_order_details',
                     insert_bottom: "[data-hook='admin_order_form_fields']",
                     partial: 'spree/admin/orders/delivery_info',
                     disabled: false)
