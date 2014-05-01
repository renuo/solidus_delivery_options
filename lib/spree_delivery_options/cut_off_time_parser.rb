module SpreeDeliveryOptions
  module CutOffTimeParser

    def cutoff_time
      cutoff_hour = SpreeDeliveryOptions::Config.delivery_cut_off_time.split(':')[0].to_i
      cutoff_minute = SpreeDeliveryOptions::Config.delivery_cut_off_time.split(':')[1].to_i

      Time.zone.now.change(hour: cutoff_hour, min: cutoff_minute)
    end
    
  end
end
