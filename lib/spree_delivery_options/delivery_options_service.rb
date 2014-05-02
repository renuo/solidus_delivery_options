module SpreeDeliveryOptions
  module DeliveryOptionsService

    private

    def current_delivery_options_for_date(delivery_date)
      if delivery_date > (Date.current + 1.day)
        delivery_options_for_date_and_time(delivery_date, "00:01")
      else
        delivery_options_for_date_and_time(delivery_date, Time.zone.now.strftime("%H:%M"))
      end
    end

    def delivery_options_for_date_and_time(delivery_date, time_string)
      current_delivery_options = delivery_options_for_time(time_string)

      date_string = delivery_date.strftime("%d/%m/%Y")
      return current_delivery_options[date_string] if current_delivery_options[date_string]

      week_day = delivery_date.strftime("%A")
      current_delivery_options[week_day.downcase] || []
    end

    def all_delivery_options_for_date(delivery_date)
      all_options = [] 
      date_string = delivery_date.strftime("%d/%m/%Y")
      week_day = delivery_date.strftime("%A").downcase

      delivery_groups.each do |cutoff_time, options|
        if options[date_string]
          all_options << {cutoff_time => options[date_string]}
        elsif options[week_day]
          all_options << {cutoff_time => options[week_day]}
        end
      end
      all_options
    end

    def delivery_options_for_time(order_time_string)
      delivery_groups.each{|cutoff_time, options| return options if order_time_string < cutoff_time}
      {}
    end

    def delivery_groups
      @delivery_groups = JSON.parse(SpreeDeliveryOptions::Config.delivery_time_options)[0] || []
    end

  end
end
