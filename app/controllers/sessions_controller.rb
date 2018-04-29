class SessionsController < ApplicationController
  def new
  end

  def create
     user = User.find_by(email: params[:session][:email].downcase)
    #メモ: &&(論理積)を使って取得したユーザーが有効かどうかを決定させる
    #   : 入力されたメールアドレスを持つユーザーがデータベースに存在し、かつ入力されたパスワードがそのユーザーのパスワードである場合のみ、if文がtrueになる
    #   : ユーザーがデータベースにあり、かつ、認証に成功した場合にのみログインできる
    if user && user.authenticate(params[:session][:password])
      # ユーザーログイン後にユーザー情報のページにリダイレクトする
      log_in user
      redirect_to user
    else
      # エラーメッセージを作成する
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    #ユーザーのログアウト
    log_out #helperでパッケージ化したものを使用(sessions_helper)
    redirect_to root_url
  end
end
