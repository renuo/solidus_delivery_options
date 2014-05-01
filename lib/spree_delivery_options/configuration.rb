module SpreeDeliveryOptions
  class Configuration < Spree::Preferences::Configuration
    preference :delivery_cut_off_time, :string, default: "13:15"
    preference :delivery_time_options, :string, default: {monday: ['Between 6am-8am']}.to_json
    preference :show_homepage_form, :boolean, default: true 
  end
end
