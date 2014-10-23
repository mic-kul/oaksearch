require 'test_helper'

class FeaturesControllerTest < ActionController::TestCase
  setup do
    @feature = features(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:features)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create feature" do
    assert_difference('Feature.count') do
      post :create, feature: { created_by: @feature.created_by, created_date: @feature.created_date, feature_id: @feature.feature_id, feature_type: @feature.feature_type, modified_by: @feature.modified_by, modified_date: @feature.modified_date, name: @feature.name }
    end

    assert_redirected_to feature_path(assigns(:feature))
  end

  test "should show feature" do
    get :show, id: @feature
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @feature
    assert_response :success
  end

  test "should update feature" do
    patch :update, id: @feature, feature: { created_by: @feature.created_by, created_date: @feature.created_date, feature_id: @feature.feature_id, feature_type: @feature.feature_type, modified_by: @feature.modified_by, modified_date: @feature.modified_date, name: @feature.name }
    assert_redirected_to feature_path(assigns(:feature))
  end

  test "should destroy feature" do
    assert_difference('Feature.count', -1) do
      delete :destroy, id: @feature
    end

    assert_redirected_to features_path
  end
end
