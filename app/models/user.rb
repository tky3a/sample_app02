class User < ApplicationRecord
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
end
