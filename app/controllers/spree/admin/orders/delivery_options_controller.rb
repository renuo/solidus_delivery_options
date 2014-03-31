module Spree
  module Admin
    module Orders
      class DeliveryOptionsController < Spree::Admin::BaseController

        def edit
          @order = Order.find_by(number: params[:order_id])
        end

        def update
          @order = Order.find_by(number: params[:order_id])
          if update_delivery_options(@order) && @order.next
            flash[:success] = Spree.t('delivery_options_updated')
          end

          render :edit
        end

        private

        def update_delivery_options(order)
          order_params = delivery_options_params
          if order_params[:delivery_date]
            @order.delivery_date = order_params.delete(:delivery_date)
            @order.save(validate: false)
          end
          @order.update_attributes(order_params)
        end

        def delivery_options_params
          params.require(:order).permit(:delivery_date, :delivery_time, :delivery_instructions)
        end

      end
    end
  end
end
