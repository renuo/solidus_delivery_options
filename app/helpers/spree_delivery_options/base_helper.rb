module SpreeDeliveryOptions
  module BaseHelper

    include ::SpreeDeliveryOptions::DeliveryOptionsService

    def current_order_cutoff_time
      return nil unless (current_order && current_order.delivery_date && current_order.delivery_time)
      
      cutoff_date = current_order.delivery_date - 1.day
      all_delivery_options = all_delivery_options_for_date(current_order.delivery_date)

      possible_cutoff_times = all_delivery_options.select{ |opt| 
        opt.values.flatten.include?(current_order.delivery_time)
      }.map{ |opt| opt.keys}.flatten rescue nil

      return nil if possible_cutoff_times.empty?

      cutoff_time = DateTime.strptime(possible_cutoff_times.sort.last, "%H:%M").strftime("%l%P").strip
      "#{cutoff_date.strftime('%A, %d %b')} before #{cutoff_time}"
    end

    def next_delivery_slot
      current_time_string = Time.zone.now.strftime("%H:%M")
      possible_delivery_day = Date.current + 1.day

      possible_delivery_day_options = delivery_options_for_date_and_time(possible_delivery_day, current_time_string)
      if !delivery_options_for_date_and_time(possible_delivery_day, current_time_string).empty?
        return "#{possible_delivery_day.strftime('%A').titleize} between #{possible_delivery_day_options.first}"
      else
        counter = 0
        until counter > 7 do
          possible_delivery_day = possible_delivery_day + 1.day
          current_time_string = "00:01"
          possible_delivery_day_options = delivery_options_for_date_and_time(possible_delivery_day, current_time_string)

          if !possible_delivery_day_options.empty?
            return "#{possible_delivery_day.strftime('%A').titleize} between #{possible_delivery_day_options.first}"
          end
          counter += 1
        end
      end

      ""
    end

  end
end
