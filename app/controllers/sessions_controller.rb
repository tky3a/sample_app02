class SessionsController < ApplicationController
  def new
  end

  def create
     @user = User.find_by(email: params[:session][:email].downcase)
    #メモ: &&(論理積)を使って取得したユーザーが有効かどうかを決定させる
    #   : 入力されたメールアドレスを持つユーザーがデータベースに存在し、かつ入力されたパスワードがそのユーザーのパスワードである場合のみ、if文がtrueになる
    #   : ユーザーがデータベースにあり、かつ、認証に成功した場合にのみログインできる
    if @user && @user.authenticate(params[:session][:password])
      log_in @user   # ユーザーログイン
      remember @user #ログインしてユーザー情報を保持する
      params[:session][:remember_me] == "1" ? remember(@user) : forget(@user)
      redirect_to @user #ログイン後にユーザー情報のページにリダイレクトする
    else
      # ログインできなかった場合、エラーメッセージを作成する
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    #ユーザーのログアウト
    log_out if logged_in? #ログイン中の場合のみログアウトする  #helperでパッケージ化したものを使用(sessions_helper)
    redirect_to root_url
  end
end
