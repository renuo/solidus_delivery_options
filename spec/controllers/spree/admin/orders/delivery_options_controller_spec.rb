require 'spec_helper'

describe Spree::Admin::Orders::DeliveryOptionsController do
  let(:user) { mock_model Spree::User, last_incomplete_spree_order: nil, has_spree_role?: true, spree_api_key: 'fake' }

  before :each do
    controller.stub spree_current_user: user
    controller.stub :check_authorization
  end

  describe 'edit' do
    it 'should render edit' do
      spree_get :edit
      response.should render_template(:edit)
    end
  end

  describe 'update' do
    let(:order) { Spree::Order.new }
    let(:tomorrow) { Date.tomorrow.strftime('%d/%m/%Y') }

    before :each do
      Spree::Order.stub(:find_by).and_return(order)
      order.stub(:update_attributes).and_return(true)
      order.stub(:save)
    end

    it 'should update delivery date and skip validation' do
      order.should_receive(:delivery_date=).with(tomorrow)
      order.should_receive(:save).with(validate: false)
      spree_post :update, order: { delivery_date: tomorrow }
    end

    it 'should update other attributes and call next if update is successful' do
      order.should_receive(:update_attributes).with('delivery_time' => '7:30am to 9am').and_return(true)
      order.should_receive(:next)
      spree_post :update, order: { delivery_date: tomorrow, delivery_time: '7:30am to 9am' }
    end

    it 'should render edit when successful' do
      spree_post :update, order: { delivery_date: tomorrow }
      response.should render_template(:edit)
    end

    it 'should render edit when unsuccessful' do
      order.should_receive(:update_attributes).with('delivery_time' => '7:30am to 9am').and_return false
      spree_post :update, order: { delivery_date: tomorrow, delivery_time: '7:30am to 9am' }
      response.should render_template(:edit)
    end

    it 'should not allow to update invalid attributes' do
      order.should_receive(:update_attributes).with('delivery_time' => '7:30am to 9am')
      spree_post :update, order: { delivery_date: tomorrow, delivery_time: '7:30am to 9am', crazy: 'blah' }
    end
  end
end
