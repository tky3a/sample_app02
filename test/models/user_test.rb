require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
            password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid?" do
    #@user.valid?: userオブジェクトは有効か検証
    assert @user.valid?
  end

  #name属性の存在性に関するテスト
  test "name should be present" do
    #nameが空の場合false
    @user.name = " "
    assert_not @user.valid?
  end

  test "email should be present" do
    #emailが空の場合false
    @user.email = " "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    #nameが51文字以上の場合false
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be long" do
    #emailが244文字以上の場合false
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  #有効なメールアドレスをテスト
  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.c]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      #どのメールアドレスでテストが失敗したのかを特定できるようになる
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  #無効なメールアドレスをテスト
  test "email validation should reject invalid addresse" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  #重複するメールアドレス拒否のテスト
  test "email address should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase #メールアドレスの大文字小文字を区別しない様にする
    @user.save
    assert_not duplicate_user.valid?
  end

  #パスワードの最小文字数をテスト
    #パスワードが空の場合falseするテスト
  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = "" * 6
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    @user.valid?
  end
end
