require 'test_helper'

class ChampionshipsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get join" do
    get :join
    assert_response :success
  end

end
