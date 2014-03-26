module SpreeDeliveryOptions
  module BaseHelper

    def next_delivery_slot
      delivery_options = JSON.parse(SpreeDeliveryOptions::Config.delivery_time_options)

      delivery_day = next_delivery_day
      return "" unless delivery_day

      "#{delivery_day.strftime('%A').titleize} between #{delivery_options[delivery_day.strftime('%A').downcase].first}"
    end

    def next_delivery_day
      delivery_options = JSON.parse(SpreeDeliveryOptions::Config.delivery_time_options)

      cutoff_time = Time.zone.now.change(hour: SpreeDeliveryOptions::Config.delivery_cut_off_hour)

      current_day = Time.zone.now > cutoff_time ? (Date.current + 2.days) : (Date.current + 1.day)
      next_available_day = nil
      counter = 0

      until next_available_day || counter > 7 do
        if delivery_options[current_day.strftime('%A').downcase]
          next_available_day = current_day
        else
          current_day = current_day + 1.day
          counter = counter + 1
        end
      end
      next_available_day
    end

  end
end
