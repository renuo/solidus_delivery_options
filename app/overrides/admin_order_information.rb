Deface::Override.new(virtual_path: 'spree/admin/shared/_order_summary',
                     name: 'add_delivery_date_to_admin_order_information',
                     insert_top: 'dl.additional-info',
                     partial: 'spree/admin/shared/admin_order_information_delivery_date',
                     disabled: false)
