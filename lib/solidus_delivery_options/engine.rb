module SolidusDeliveryOptions
  class Engine < Rails::Engine
    require 'spree/core'

    engine_name 'solidus_delivery_options'

    config.autoload_paths += %W[#{config.root}/lib]

    config.generators do |g|
      g.test_framework :rspec
    end

    isolate_namespace Spree

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/helpers/**.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    config.to_prepare &method(:activate).to_proc

    initializer 'spree.delivery_options.preferences', after: 'spree.environment' do |_app|
      SolidusDeliveryOptions::Config = Spree::DeliveryOptionsConfiguration.new
    end
  end
end
