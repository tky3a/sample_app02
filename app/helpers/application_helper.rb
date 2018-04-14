module ApplicationHelper
    # ページごとの完全なタイトルを返します。
    def full_title(page_title = "")
      base_title = "Ruby on Rails Tutorial Sample App"
      #もしpage_titleが設定されていない場合はbase_titleのみ表示
      if page_title.empty?
        base_title
      #page_titleが設定されている場合は下記のように表示
      else
        page_title +"|"+ base_title
      end
    end
end
