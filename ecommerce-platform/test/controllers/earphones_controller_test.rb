require 'test_helper'

class EarphonesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @earphone = earphones(:one)
  end

  test "should get index" do
    get earphones_url
    assert_response :success
  end

  test "should get new" do
    get new_earphone_url
    assert_response :success
  end

  test "should create earphone" do
    assert_difference('Earphone.count') do
      post earphones_url, params: { earphone: { image: @earphone.image, price: @earphone.price, title: @earphone.title } }
    end

    assert_redirected_to earphone_url(Earphone.last)
  end

  test "should show earphone" do
    get earphone_url(@earphone)
    assert_response :success
  end

  test "should get edit" do
    get edit_earphone_url(@earphone)
    assert_response :success
  end

  test "should update earphone" do
    patch earphone_url(@earphone), params: { earphone: { image: @earphone.image, price: @earphone.price, title: @earphone.title } }
    assert_redirected_to earphone_url(@earphone)
  end

  test "should destroy earphone" do
    assert_difference('Earphone.count', -1) do
      delete earphone_url(@earphone)
    end

    assert_redirected_to earphones_url
  end
end
