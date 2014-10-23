require 'test_helper'

class StoreproductsControllerTest < ActionController::TestCase
  setup do
    @storeproduct = storeproducts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:storeproducts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create storeproduct" do
    assert_difference('Storeproduct.count') do
      post :create, storeproduct: {  }
    end

    assert_redirected_to storeproduct_path(assigns(:storeproduct))
  end

  test "should show storeproduct" do
    get :show, id: @storeproduct
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @storeproduct
    assert_response :success
  end

  test "should update storeproduct" do
    patch :update, id: @storeproduct, storeproduct: {  }
    assert_redirected_to storeproduct_path(assigns(:storeproduct))
  end

  test "should destroy storeproduct" do
    assert_difference('Storeproduct.count', -1) do
      delete :destroy, id: @storeproduct
    end

    assert_redirected_to storeproducts_path
  end
end
