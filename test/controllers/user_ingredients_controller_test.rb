require 'test_helper'

class UserIngredientsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get user_ingredients_index_url
    assert_response :success
  end

  test "should get new" do
    get user_ingredients_new_url
    assert_response :success
  end

  test "should get create" do
    get user_ingredients_create_url
    assert_response :success
  end

  test "should get show" do
    get user_ingredients_show_url
    assert_response :success
  end

  test "should get edit" do
    get user_ingredients_edit_url
    assert_response :success
  end

  test "should get update" do
    get user_ingredients_update_url
    assert_response :success
  end

  test "should get destroy" do
    get user_ingredients_destroy_url
    assert_response :success
  end

end
