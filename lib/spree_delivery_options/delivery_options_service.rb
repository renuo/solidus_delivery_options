module SpreeDeliveryOptions
  module DeliveryOptionsService

    private

    def cutoff_time
      cutoff_hour = SpreeDeliveryOptions::Config.delivery_cut_off_time.split(':')[0].to_i
      cutoff_minute = SpreeDeliveryOptions::Config.delivery_cut_off_time.split(':')[1].to_i

      Time.zone.now.change(hour: cutoff_hour, min: cutoff_minute)
    end

    def delivery_options_for(time_string)
      return delivery_groups[earliest_delivery_group(time_string)] rescue nil
    end

    def earliest_cutoff_time(time)
      cutoff_groups[earliest_delivery_group(time.strftime("%H:%M"))]["cutoff_time"] rescue nil
    end

    def earliest_delivery_group(time_string)
      puts time_string
      puts cutoff_groups
      cutoff_groups.each do |id, group|
        return id if time_string < group["cutoff_time"]
      end
      nil
    end

    def latest_cutoff_time(order)
      cutoff_times = []
      available_delivery_groups(order).each do |group_id|
        cutoff_times << cutoff_groups[group_id]["cutoff_time"]
      end

      return cutoff_times.sort.last unless cutoff_times.empty?
      nil
    end

    def available_delivery_groups(order)
      week_day = order.delivery_date.strftime("%A").downcase
      available_groups_ids = [] 
      delivery_groups.each do |id, options|
        available_groups_ids << id if options[week_day] && options[week_day].include?(order.delivery_time)
      end
      available_groups_ids
    end

    def delivery_groups
      @delivery_groups = JSON.parse(SpreeDeliveryOptions::Config.delivery_time_options)
    end

    def cutoff_groups
      @cutoff_groups = JSON.parse(SpreeDeliveryOptions::Config.delivery_cut_off_time)
    end

  end
end
