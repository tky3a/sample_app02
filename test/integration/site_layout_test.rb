require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  #サイト内のリンクが正しく動作しているかテスト
    test "layout links" do
      get root_path
      #homeページ内のリンクが正しいかテスト
      assert_template 'static_pages/home'
      #root_pathへのリンクは２個あるかテスト
      assert_select "a[href=?]", root_path, count: 2
      #help_pathへのリンクがあるかテスト
      assert_select "a[href=?]", help_path
      #about_pathへのリンクがあるかテスト
      assert_select "a[href=?]", about_path
      #contact_pathへのリンクがあるかテスト
      assert_select "a[href=?]", contact_path
  end
end
