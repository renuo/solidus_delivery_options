class AddDeliveryInstructions < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_orders, :delivery_instructions, :text
  end
end
