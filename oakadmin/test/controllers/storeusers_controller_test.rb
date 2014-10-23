require 'test_helper'

class StoreusersControllerTest < ActionController::TestCase
  setup do
    @storeuser = storeusers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:storeusers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create storeuser" do
    assert_difference('Storeuser.count') do
      post :create, storeuser: {  }
    end

    assert_redirected_to storeuser_path(assigns(:storeuser))
  end

  test "should show storeuser" do
    get :show, id: @storeuser
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @storeuser
    assert_response :success
  end

  test "should update storeuser" do
    patch :update, id: @storeuser, storeuser: {  }
    assert_redirected_to storeuser_path(assigns(:storeuser))
  end

  test "should destroy storeuser" do
    assert_difference('Storeuser.count', -1) do
      delete :destroy, id: @storeuser
    end

    assert_redirected_to storeusers_path
  end
end
