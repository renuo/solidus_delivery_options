module Spree
  module Admin
    module OrdersControllerDecorator
      def index
        if params.dig(:q, :delivery_date_gt).present?
          params[:q][:delivery_date_gt] = begin
                                            parse_date_param(:delivery_date_gt).beginning_of_day
                                          rescue StandardError
                                            ""
                                          end
        end

        if params.dig(:q, :delivery_date_lt).present?
          params[:q][:delivery_date_lt] = begin
                                            parse_date_param(:delivery_date_lt).end_of_day
                                          rescue StandardError
                                            ""
                                          end
        end

        super
      end

      private

      def parse_date_param(param)
        Time.zone.parse(params[:q][param])
      end
    end
  end
end

Spree::Admin::OrdersController.prepend Spree::Admin::OrdersControllerDecorator

Spree::Order.whitelisted_ransackable_attributes << 'delivery_date'
