class AddDeliveryTimeToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_orders, :delivery_time, :string
  end
end
