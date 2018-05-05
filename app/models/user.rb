class User < ApplicationRecord
  #記憶トークンのアクセサーを定義する（attr_accessorで定義することで、remember_tokenが利用可能になった）
  attr_accessor :remember_token
  #before_save: オブジェクトが保存される前に実行する
  #selfオプション: 現在のユーザーを指す
  #保存前にemailを小文字に変換
  before_save { self.email = email.downcase }

  #nameのvalidation
  validates :name, presence: true, length: { maximum: 50 }

  #正規表現を変数に代入
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  #emailのvalidation
  validates :email, presence: true, length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX }, #正規表現のパターンに当てはまるメールアドレスのみを許可
            uniqueness: { case_sensitive: false } #uniquenes: 重複登録をfalseにする.
                                                    #尚且つcese_sensitiveオプションで大文字小文字を区別しない様にする

  has_secure_password #has_secure_passwordを追加するとできる事(モデルのカラムにpassword_digestを追加している必要がある)
                      # 1. セキュアにハッシュ化したパスワードを、データベース内のpassword_digestという属性に保存できるようになる。
                      # 2. 2つのペアの仮想的な属性 (passwordとpassword_confirmation) が使えるようになる。
                      #    また、存在性と値が一致するかどうかのバリデーションも追加される.
                      #3. authenticateメソッドが使えるようになる.
                      #  (引数の文字列がパスワードと一致するとUserオブジェクトを、間違っているとfalseを返すメソッド) 。

  #passwordのvalidation
  validates :password, presence: true, length: { minimum: 6 }

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                            BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  #ランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  #永続セッションのためにユーザーをデータベースに記憶する
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
    #update_attribute : データベースに記憶した情報を更新　
  end

  # 渡されたトークンがダイジェストと一致したらtrueを返す. ※このremember_tokenは、attr_accessor :remember_tokenで定義したアクセサとは異なる
  def authenticated?(remember_token)#?は真偽値の為、trueかfalseを返す
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil) #ログイン情報をnilに更新する
  end
end
