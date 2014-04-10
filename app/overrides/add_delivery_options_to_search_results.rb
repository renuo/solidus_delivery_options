Deface::Override.new(:virtual_path => "spree/products/index",
                     :name => "add_delivery_options_to_search_results",
                     :insert_top => "[data-hook='search_results']",
                     :partial => "spree/shared/delivery_options",
                     :disabled => false)
