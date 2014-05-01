require 'spec_helper'

describe Spree::Order do

  let(:order){Spree::Order.new}

  before :each do
    SpreeDeliveryOptions::Config.delivery_time_options = {monday: ['Between 6-7am']}.to_json
    SpreeDeliveryOptions::Config.delivery_cut_off_time = "13:15"
  end

  describe 'valid_delivery_instructions' do

    it 'should accept nil delivery instructions' do
      order.delivery_instructions = nil
      order.valid_delivery_instructions?.should be_true
      order.errors[:delivery_instructions].should be_empty
    end

    it 'should accept empty delivery instructions' do
      order.delivery_instructions = ""
      order.valid_delivery_instructions?.should be_true
      order.errors[:delivery_instructions].should be_empty
    end

    it 'should accept valid delivery instructions' do
      order.delivery_instructions = "This is awesome"
      order.valid_delivery_instructions?.should be_true
      order.errors[:delivery_instructions].should be_empty
    end

    it 'should not accept delivery instructions that are too long' do
      order.delivery_instructions = "A" * 501
      order.valid_delivery_instructions?.should be_false
      order.errors[:delivery_instructions].should_not be_empty
    end

  end

  describe "delivery_date_present" do

    it 'should require delivery date' do
      order.delivery_date_present?.should == false
      order.errors[:delivery_date].should_not be_empty
    end

  end

  describe 'delivery_time_present' do

    it 'should require delivery time' do
      order.delivery_date = Date.today

      order.delivery_time_present?.should == false
      order.errors[:delivery_time].should_not be_empty
    end

  end

  describe "valid_delivery_options?" do

    before :each do
      SpreeDeliveryOptions::Config.delivery_time_options = {monday: ['Between 6-7am']}.to_json
    end

    it 'should not be valid if delivery date is in the past' do
      order.delivery_date = Date.yesterday
      order.delivery_time = 'Between 6-7am'
      order.valid_delivery_options?.should == false
      order.errors[:delivery_date].should_not be_empty
    end

    it 'should not be valid if delivery date is today' do
      order.delivery_date = Date.today
      order.delivery_time = 'Between 6-7am'
      order.valid_delivery_options?.should == false
      order.errors[:delivery_date].should_not be_empty
    end

    it 'should be valid if delivery date is tomorrow and it is before the cutoff time' do
      time_now = DateTime.parse("17/11/2013 13:14 +1100", "%d/%m/%Y %H:%M %z")
      Timecop.freeze(time_now)

      order.delivery_date = '18/11/2013'
      order.delivery_time = 'Between 6-7am'

      order.valid_delivery_options?.should == true
      order.errors[:delivery_date].should be_empty
      Timecop.return
    end

    it 'should be valid if delivery date is tomorrow but is before the cutoff time' do
      time_now = DateTime.parse("17/11/2013 13:16 +1100", "%d/%m/%Y %H:%M %z")
      Timecop.freeze(time_now)

      order.delivery_date = '18/11/2013'
      order.delivery_time = 'Between 6-7am'

      order.valid_delivery_options?.should == false
      order.errors[:delivery_date].should_not be_empty
      Timecop.return
    end

    context 'delivery time' do

      before :each do
        SpreeDeliveryOptions::Config.delivery_time_options = {monday: ['Between 6-7am']}.to_json
      end

      it 'should require a valid option for delivery time' do
        order.delivery_date = Date.today

        order.delivery_time = 'crazy times!'
        order.valid_delivery_options?.should == false
        order.errors[:delivery_date].should_not be_empty
      end

      it 'should allow valid delivery time' do
        time_now = DateTime.parse("05/04/2014 10:00 +1100", "%d/%m/%Y %H:%M %z")
        Timecop.freeze(time_now)

        order.delivery_date = Date.parse('07/04/2014')
        order.delivery_time = 'Between 6-7am'
        
        order.valid_delivery_options?.should == true
        Timecop.return
      end

      it 'should not allow invalid delivery time for the date' do
        time_now = DateTime.parse("05/04/2014 10:00 +1100", "%d/%m/%Y %H:%M %z")
        Timecop.freeze(time_now)

        order.delivery_date = Date.parse('07/04/2014')
        order.delivery_time = '6am to 7:30am'

        order.valid_delivery_options?.should == false
        order.errors[:delivery_time].should_not be_empty
        Timecop.return
      end

      it 'should not allow date without delivery time' do
        time_now = DateTime.parse("05/04/2014 10:00 +1100", "%d/%m/%Y %H:%M %z")
        Timecop.freeze(time_now)

        order.delivery_date = Date.parse('08/04/2014')
        order.delivery_time = 'Between 6-7am'
        
        order.valid_delivery_options?.should == false
        order.errors[:delivery_date].should_not be_empty
        Timecop.return
      end

    end

    context "overriding delivery day with specific date" do

      it 'should not allow delivery time to be in an invalid slot for the delivery day' do
        SpreeDeliveryOptions::Config.delivery_time_options = {monday: ['Between 6-7am'], '03/03/2014' => ['Between 9-12am']}.to_json

        time_now = DateTime.parse("01/03/2014")
        Timecop.freeze(time_now)

        order.delivery_date =  Date.parse('03/03/2014')
        order.delivery_time = 'Between 6-7am'

        order.valid_delivery_options?.should == false
        order.errors[:delivery_time].should_not be_empty
        Timecop.return
      end

      it 'should not allow delivery time to be in date with empty options' do
        SpreeDeliveryOptions::Config.delivery_time_options = {monday: ['Between 6-7am'], '03/03/2014' => []}.to_json

        time_now = DateTime.parse("01/03/2014")
        Timecop.freeze(time_now)

        order.delivery_date =  Date.parse('03/03/2014')
        order.delivery_time = 'Between 6-7am'

        order.valid_delivery_options?.should == false
        order.errors[:delivery_time].should_not be_empty
        Timecop.return
      end

    end

  end

end
