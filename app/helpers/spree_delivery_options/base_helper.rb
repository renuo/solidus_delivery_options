module SpreeDeliveryOptions
  module BaseHelper

    include ::SpreeDeliveryOptions::DeliveryOptionsService

    def current_order_cutoff_time
      return nil unless (current_order && current_order.delivery_date && current_order.delivery_time)
      
      cutoff_date = current_order.delivery_date - 1.day
      order_week_day = current_order.delivery_date.strftime('%A').downcase

      possible_cutoff_times = delivery_groups.select {|cutoff_time, options| 
        options[order_week_day].include?(current_order.delivery_time)
      }.map{|cutoff_time, options| cutoff_time} rescue nil

      return nil unless possible_cutoff_times

      cutoff_time = DateTime.strptime(possible_cutoff_times.sort.last, "%H:%M").strftime("%l%P").strip
      "#{cutoff_date.strftime('%A, %d %b')} before #{cutoff_time}"
    end

    def next_delivery_slot
      first_possible_delivery_day = Date.current + 1.day
      current_time_string = Time.zone.now.strftime("%H:%M")

      available_delivery_options = delivery_options_for_time(current_time_string)
      unless available_delivery_options
        first_possible_delivery_day += 1.day
        available_delivery_options = delivery_options_for_time("00:01")
      end
      return "" unless available_delivery_options

      delivery_day = next_available_day(first_possible_delivery_day, available_delivery_options)
      "#{delivery_day.strftime('%A').titleize} between #{available_delivery_options[delivery_day.strftime('%A').downcase].first}"
    end

    def delivery_options_for_time(time_string)
      delivery_groups.each{|cutoff_time, options| return options if time_string < cutoff_time}
      nil
    end

    def next_available_day(current_day, available_options)
      next_available_day = nil
      counter = 0
      until next_available_day || counter > 7 do
        if available_options[current_day.strftime('%A').downcase]
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
