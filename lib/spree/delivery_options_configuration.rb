module Spree
  class DeliveryOptionsConfiguration < Spree::Preferences::Configuration
    preference :delivery_cut_off_time, :string, default: [{ cutoff_time: "13:15", id: :morning }, { cutoff_time: "23:59", id: :evening }].to_json
    preference :delivery_time_options, :string, default: { morning: { monday: ['Between 6-7am'] }, evening: { monday: ['6pm to 7:30pm'] } }.to_json
    preference :show_homepage_form, :boolean, default: true
  end
end
