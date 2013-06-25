require 'test_helper'

class RetweetsControllerTest < ActionController::TestCase
  setup do
    @retweet = retweets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:retweets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create retweet" do
    assert_difference('Retweet.count') do
      post :create, retweet: { content: @retweet.content, poster_id: @retweet.poster_id, user_id: @retweet.user_id }
    end

    assert_redirected_to retweet_path(assigns(:retweet))
  end

  test "should show retweet" do
    get :show, id: @retweet
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @retweet
    assert_response :success
  end

  test "should update retweet" do
    patch :update, id: @retweet, retweet: { content: @retweet.content, poster_id: @retweet.poster_id, user_id: @retweet.user_id }
    assert_redirected_to retweet_path(assigns(:retweet))
  end

  test "should destroy retweet" do
    assert_difference('Retweet.count', -1) do
      delete :destroy, id: @retweet
    end

    assert_redirected_to retweets_path
  end
end
