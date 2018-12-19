class AddDeliveryDateToOrders < ActiveRecord::Migration[5.2]
  def up
    add_column :spree_orders, :delivery_date, :date
  end

  def down
    remove_column :spree_orders, :delivery_date
  end
end
