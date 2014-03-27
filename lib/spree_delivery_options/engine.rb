module SpreeDeliveryOptions
  class Engine < Rails::Engine
    require 'spree/core'

    isolate_namespace Spree

    initializer "spree.spree_delivery_options.preferences", :after => "spree.environment" do |app|
       SpreeDeliveryOptions::Config = SpreeDeliveryOptions::Configuration.new
    end

    engine_name 'spree_delivery_options'

    config.autoload_paths += %W(#{config.root}/lib)

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/helpers/**.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end


    config.to_prepare &method(:activate).to_proc
  end
end
