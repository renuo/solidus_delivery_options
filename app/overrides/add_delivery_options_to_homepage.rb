Deface::Override.new(:virtual_path => "spree/layouts/spree_application",
                     :name => "add_delivery_options_to_homepage",
                     :insert_top => "#wrapper",
                     :partial => "spree/layouts/delivery_options",
                     :disabled => false)
