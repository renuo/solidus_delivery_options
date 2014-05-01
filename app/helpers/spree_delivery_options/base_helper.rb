module SpreeDeliveryOptions
  module BaseHelper

    include ::SpreeDeliveryOptions::DeliveryOptionsService

    def current_order_cutoff_time
      return nil unless (current_order && current_order.delivery_date && current_order.delivery_time)
      
      cutoff_date = current_order.delivery_date - 1.day
      cutoff_time = DateTime.strptime(latest_cutoff_time(current_order), "%H:%M").strftime("%l%P").strip
      "#{cutoff_date.strftime('%A, %d %b')} before #{cutoff_time}"
    end

    def next_delivery_slot
      delivery_day = next_delivery_day
      return "" unless delivery_day

      "#{delivery_day.strftime('%A').titleize} between #{delivery_options_for(Time.zone.now.strftime("%H:%M"))[delivery_day.strftime('%A').downcase].first}"
    end

    def next_delivery_day
      current_day = nil
      delivery_options_for_now = nil
      if earliest_cutoff_time(Time.zone.now).nil?
        current_day = (Date.current + 2.days)
        delivery_options_for_now = delivery_options_for("00:01")
      else
        current_day = (Date.current + 1.day)
        delivery_options_for_now = delivery_options_for(Time.zone.now.strftime("%H:%M"))
      end

      return nil unless delivery_options_for_now

      next_available_day = nil
      counter = 0
      until next_available_day || counter > 7 do
        if delivery_options_for_now[current_day.strftime('%A').downcase]
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
