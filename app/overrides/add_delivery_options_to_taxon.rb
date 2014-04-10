Deface::Override.new(:virtual_path => "spree/taxons/show",
                     :name => "add_delivery_options_to_taxon",
                     :insert_before => "h1.taxon-title",
                     :partial => "spree/shared/delivery_options",
                     :disabled => false)
