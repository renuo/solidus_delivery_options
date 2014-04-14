require 'spec_helper'

describe SpreeDeliveryOptions::BaseHelper do

  describe 'current order cutoff time' do

    let(:order){FactoryGirl.build(:order)}

    before :each do
      helper.stub(:current_order).and_return(order)
    end
    
    it 'should return nil if there is no current order' do
      helper.stub(:current_order).and_return(nil)
      helper.current_order_cutoff_time.should be_nil
    end

    it 'should return nil if there current order has no delivery date' do
      order.delivery_date = nil
      helper.current_order_cutoff_time.should be_nil
    end

    it 'should return the day before if delivery date is set' do
      SpreeDeliveryOptions::Config.delivery_cut_off_hour = 13
      order.delivery_date = Date.parse('23/04/2014')

      time_now = DateTime.parse("20/03/2013")
      Timecop.freeze(time_now)
      helper.current_order_cutoff_time.should == 'Tuesday, 22 Apr before  1pm'
      Timecop.return
    end

  end

  describe 'next delivery slot' do

    it 'should return first slot for tomorrow if its before cutoff time' do
      SpreeDeliveryOptions::Config.delivery_time_options = {monday: ['6am-7am', '7am-9am'], tuesday: ['9am-12pm']}.to_json
      time_now = DateTime.parse("10/03/2014 #{SpreeDeliveryOptions::Config.delivery_cut_off_hour-1}:00 +1100")
      Timecop.freeze(time_now)

      helper.next_delivery_slot.should == 'Tuesday between 9am-12pm'
      Timecop.return
    end

    it 'should return the day after tomorrow morning if its after cutoff time' do
      SpreeDeliveryOptions::Config.delivery_time_options = {monday: ['6am-7am', '7am-9am'], tuesday: ['9am-12pm'], wednesday: ['9am-12pm']}.to_json
      time_now = DateTime.parse("10/03/2014 #{SpreeDeliveryOptions::Config.delivery_cut_off_hour+1}:00 +1100")
      Timecop.freeze(time_now)

      helper.next_delivery_slot.should == 'Wednesday between 9am-12pm'
      Timecop.return
    end

    it 'should skip day if deliveries are not available' do
      SpreeDeliveryOptions::Config.delivery_time_options = {monday: ['6am-7am', '7am-9am'], tuesday: ['9am-12pm'], wednesday: ['9am-12pm']}.to_json
      time_now = DateTime.parse("13/03/2014 #{SpreeDeliveryOptions::Config.delivery_cut_off_hour+1}:00 +1100")
      Timecop.freeze(time_now)

      helper.next_delivery_slot.should == 'Monday between 6am-7am'
      Timecop.return
    end

    it 'should return nil if no delivery times are avaialble' do
      SpreeDeliveryOptions::Config.delivery_time_options = {}.to_json
      time_now = DateTime.parse("13/03/2014 #{SpreeDeliveryOptions::Config.delivery_cut_off_hour+1}:00 +1100")
      Timecop.freeze(time_now)

      helper.next_delivery_slot.should == ''
      Timecop.return
    end

  end

end
