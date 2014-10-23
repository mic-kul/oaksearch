require 'test_helper'

class OffersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get make_offer" do
    get :make_offer
    assert_response :success
  end

  test "should get make_offer_save" do
    get :make_offer_save
    assert_response :success
  end

end
