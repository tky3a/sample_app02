require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  #無効なユーザー登録に対するテスト
  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: {user: {name: "",
                                      email: "user@invalid",
                                      password: "foo",
                                      password_confirmation: "bar"}}
    end
    assert_template 'users/new' #登録が無効なユーザーはusers/newページが表示されるかテスト
  end

  #有効なユーザー登録に対するテスト
  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: {user: {name: "Example User",
                                email: "user@example.com",
                                password: "password",
                                password_confirmation: "password" }}
      end
      follow_redirect! #user登録後にusers/showにアクセスできるかテスト
      assert_template 'users/show'
      assert_not flash.alert #登録後にflashメッセージが表示されるかテスト
      assert is_logged_in?
  end


end
