Solidus Delivery Options
=================

This gem is a fork from [spree_delivery_date](from 'https://github.com/sgringwe/spree_delivery_date'), and it has been updated to work with spree_core 2.1.3, as well as other changes. 

Requires user to enter a delivery date and delivery time during checkout (delivery section).

Features
-------

* Delivery date validation
	* Creates a cut off time for deliveries done the day after
	* If order is being done before cut off time, delivery date can be set to the day after
	* If order is after cut off time, delivery date can only be set to the day after + 1

* Shows delivery date and time during checkout confirmation.
* Shows delivery date when viewing or editing order as admin.
* Allows admin to filter orders by delivery date and time (date range).
* Allows admin to sort orders by delivery date and time.
* Adds delivery date column to orders index page table.
* Adds delivery options banner to taxons page (configurable)


Installation
------------

Add the gem to your Gemfile

    $ gem 'solidus_delivery_options'

bundle with
  
    $ bundle update

and run

    $ rails g solidus_delivery_options:install

to install and (be asken to) run the migrations. This migration simply adds the delivery_date field to Spree::Order.

Configuration
-------------

Both the delivery cut off hour and the delivery time options can be configured in your application.rb file

     config.after_initialize do
        delivery_time_options = [
          { 13:00 =>
            {
              monday: ["Before 6am", "9-12 am"],
              tuesday: ["Before 6am", "9-12 am"]
            }
          }
        ].to_json
        SolidusDeliveryOptions::Config.delivery_time_options = delivery_time_options
      end

The delivery options for any weekday can be overriden by specifying a date in dd/mm/yyyy format (i.e. for different times in public holidays). 

      delivery_time_options = [
        { 13:00 =>
          {
            "12/02/2014"  => ["9-12am"],
            monday: ["Before 6am", "9-12 am"],
            tuesday: ["Before 6am", "9-12 am"]
          }
        }
      ].to_json
