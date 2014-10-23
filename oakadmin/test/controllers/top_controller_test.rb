require 'test_helper'

class TopControllerTest < ActionController::TestCase
  test "should get products" do
    get :products
    assert_response :success
  end

  test "should get stores" do
    get :stores
    assert_response :success
  end

end
