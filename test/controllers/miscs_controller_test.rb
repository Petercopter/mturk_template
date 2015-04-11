require 'test_helper'

class MiscsControllerTest < ActionController::TestCase
  setup do
    @misc = miscs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:miscs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create misc" do
    assert_difference('Misc.count') do
      post :create, misc: {  }
    end

    assert_redirected_to misc_path(assigns(:misc))
  end

  test "should show misc" do
    get :show, id: @misc
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @misc
    assert_response :success
  end

  test "should update misc" do
    patch :update, id: @misc, misc: {  }
    assert_redirected_to misc_path(assigns(:misc))
  end

  test "should destroy misc" do
    assert_difference('Misc.count', -1) do
      delete :destroy, id: @misc
    end

    assert_redirected_to miscs_path
  end
end
