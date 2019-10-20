require 'test_helper'

class UserIngredientCostsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get user_ingredient_costs_index_url
    assert_response :success
  end

  test "should get new" do
    get user_ingredient_costs_new_url
    assert_response :success
  end

  test "should get create" do
    get user_ingredient_costs_create_url
    assert_response :success
  end

  test "should get show" do
    get user_ingredient_costs_show_url
    assert_response :success
  end

  test "should get edit" do
    get user_ingredient_costs_edit_url
    assert_response :success
  end

  test "should get update" do
    get user_ingredient_costs_update_url
    assert_response :success
  end

  test "should get destroy" do
    get user_ingredient_costs_destroy_url
    assert_response :success
  end

end
