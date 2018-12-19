Deface::Override.new(virtual_path: 'spree/admin/shared/_order_submenu',
                     name: 'add_delivery_info_to_order_details',
                     insert_bottom: "[data-hook='admin_order_tabs']",
                     partial: 'spree/admin/shared/delivery_options_link',
                     disabled: false)
