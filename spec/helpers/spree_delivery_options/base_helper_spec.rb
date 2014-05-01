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

    it 'should return nil if current order has no delivery date' do
      order.delivery_date = nil
      helper.current_order_cutoff_time.should be_nil
    end

    it 'should return nil if current order has no delivery time' do
      order.delivery_date = Date.parse('23/04/2014')
      order.delivery_time = nil
      helper.current_order_cutoff_time.should be_nil
    end

    it 'should return nil if delivery time is invalid' do
      order.delivery_date = Date.parse('23/04/2014')
      order.delivery_time = "crazy!" 
      helper.current_order_cutoff_time.should be_nil
    end

    it 'should return the correct delivery group cut off time depending on the delivery time' do
      SpreeDeliveryOptions::Config.delivery_time_options = {"13:15" => {monday: ['6am to 7:30am']}, "20:00" => {monday: ['6pm to 7:30pm']}}.to_json

      order.delivery_date = Date.parse('21/04/2014')
      order.delivery_time = '6pm to 7:30pm'

      time_now = DateTime.parse("18/03/2013")
      Timecop.freeze(time_now)
      helper.current_order_cutoff_time.should == 'Sunday, 20 Apr before 8pm'
      Timecop.return
    end

    it 'should return the latest one if time is in both' do
      SpreeDeliveryOptions::Config.delivery_time_options = {"13:15" => {monday: ['6pm to 7:30pm']}, "20:00" => {monday: ['6pm to 7:30pm']}}.to_json

      order.delivery_date = Date.parse('21/04/2014')
      order.delivery_time = '6pm to 7:30pm'

      time_now = DateTime.parse("18/03/2013")
      Timecop.freeze(time_now)
      helper.current_order_cutoff_time.should == 'Sunday, 20 Apr before 8pm'
      Timecop.return
    end

  end

  describe 'next delivery slot' do

    before :each do
      SpreeDeliveryOptions::Config.delivery_time_options = {"13:15" => {tuesday: ['6am to 7:30am'], wednesday: ['6am to 7:30am']}, "20:00" => {tuesday: ['6pm to 7:30pm']}}.to_json
    end

    after :each do
      Timecop.return
    end

    it 'should return first slot for tomorrow morning if its before cutoff time' do
      time_now = DateTime.parse("10/03/2014 12:00 +1100")
      Timecop.freeze(time_now)

      helper.next_delivery_slot.should == 'Tuesday between 6am to 7:30am'
    end

    it 'should return first slot for tomorrow evening if its before evening cutoff time' do
      time_now = DateTime.parse("10/03/2014 14:00 +1100")
      Timecop.freeze(time_now)

      helper.next_delivery_slot.should == 'Tuesday between 6pm to 7:30pm'
    end

    it 'should return the day after tomorrow morning if its after evening cutoff time' do
      time_now = DateTime.parse("10/03/2014 20:01 +1100")
      Timecop.freeze(time_now)

      helper.next_delivery_slot.should == 'Wednesday between 6am to 7:30am'
    end

    it 'should skip day if deliveries are not available' do
      time_now = DateTime.parse("13/03/2014 12:00 +1100")
      Timecop.freeze(time_now)

      helper.next_delivery_slot.should == 'Tuesday between 6am to 7:30am'
    end

    it 'should return nil if no delivery times are available' do
      SpreeDeliveryOptions::Config.delivery_time_options = {}.to_json
      time_now = DateTime.parse("13/03/2014 12:00 +1100")
      Timecop.freeze(time_now)

      helper.next_delivery_slot.should == ''
      Timecop.return
    end

  end

end
