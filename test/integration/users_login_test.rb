require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test 'login with invalid information' do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: '', password: '' } }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "login with valid information followed by logout" do
    get login_path #login_path取得
    post login_path, params: { session: { email: @user.email,
                                        password: 'password' }}
    assert is_logged_in?
    assert_redirected_to @user #リダイレクト先が正しいかどうかをチェック
    follow_redirect! #そのページに実際に移動(@user) (users/show)
    assert_template 'users/show' #users/showが表示されたか確認
    assert_select 'a[href=?]', login_path, count: 0 #login_pathのリンクが０であればtrue
    assert_select 'a[href=?]', logout_path
    assert_select 'a[href=?]', user_path(@user) #user_pathへのリンクがあるかテスト

    delete logout_path #サインアウトできているか確認テスト
    assert_not is_logged_in? #サインインしていなければtrue
    assert_redirected_to root_url #rootページへのリダイレクトが正しいか確認
    # 2番目のウィンドウでログアウトをクリックするユーザーをシミュレートする
    delete logout_path
    follow_redirect! #実際にそのページへ移動
    assert_select 'a[href=?]', login_path #ログアウト後にlogin_pathがあるか確認
    assert_select 'a[href=?]', logout_path, count: 0 #ログアウト後にlogout_pathが表示されていないか確認
    assert_select 'a[href=?]', user_path(@user), count: 0 #ログアウト後にユーザーでログインしていないか確認
  end

  test "login with remembering" do
    log_in_as(@user, remember_me: '1')
    assert_equal cookies['remember_token'], assigns(:user).remember_token
  end

  test "login without remembering" do
    # クッキーを保存してログイン
    log_in_as(@user, remember_me: '1')
    delete logout_path
    #クッキーを削除
    log_in_as(@user, remember_me: '0')
    assert_empty cookies['remember_token']
  end
end
