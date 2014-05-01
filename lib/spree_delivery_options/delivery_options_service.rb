module SpreeDeliveryOptions
  module DeliveryOptionsService

    private

    def delivery_groups
      @delivery_groups = JSON.parse(SpreeDeliveryOptions::Config.delivery_time_options)
    end

    def cutoff_groups
      @cutoff_groups = JSON.parse(SpreeDeliveryOptions::Config.delivery_cut_off_time)
    end

  end
end
