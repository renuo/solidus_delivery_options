module SolidusDeliveryOptions
  module BaseHelper
    include ::SolidusDeliveryOptions::DeliveryOptionsService

    def current_order_cutoff_time
      return nil unless (current_order && current_order.delivery_date && current_order.delivery_time)

      cutoff_date = current_order.delivery_date - 1.day
      all_delivery_options = all_delivery_options_for_date(current_order.delivery_date)

      possible_cutoff_times = all_delivery_options.select do |option|
        option.values.flatten.include?(current_order.delivery_time)
      end.map(&:keys).flatten rescue nil

      return nil if possible_cutoff_times.empty?

      cutoff_time = DateTime.strptime(possible_cutoff_times.sort.last, '%H:%M').strftime('%l%P').strip
      "#{cutoff_date.strftime('%A, %d %b')} before #{cutoff_time}"
    end

    def next_delivery_slot
      current_time_string = Time.zone.now.strftime('%H:%M')
      possible_delivery_day = Date.current + 1.day

      next_delivery_slot_for(possible_delivery_day, current_time_string)
    end

    def next_delivery_slot_for(delivery_date, time_string, counter = 0)
      return '' if counter == 7 #break after cycling through the week

      possible_delivery_options = delivery_options_for_date_and_time(delivery_date, time_string)
      unless possible_delivery_options.empty?
        return "#{delivery_date.strftime('%A').titleize} between #{possible_delivery_options.first}"
      end

      next_delivery_slot_for(delivery_date + 1.day, '00:01', counter + 1)
    end
  end
end
