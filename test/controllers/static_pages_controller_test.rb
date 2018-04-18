require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest

  def setup
    @base_title = "Ruby on Rails Tutorial Sample App"
  end

  test "should get root" do
    get root_path
    assert_response :success
  end

  #homeアクションに対するテスト
  test "should get home" do
    ##static_pages_homeにアクセスすると成功するはず
    #アクセスできればGreen出来なければRed
    get static_pages_home_url
    assert_response :success
    ##assert_select:特定のHTMLタグが存在するかテストする
    #この場合titleタグが存在していて、タイトルが下記の様に表示されているか検証
    assert_select "title", "#{@base_title}"
  end

  #helpアクションに対するテスト
  test "should get help" do
    ##(static_pages_)helpにアクセスすると成功するはず
    #アクセスできればGreen出来なければRed
    #get static_pages_help_url
    get help_url
    assert_response :success
    ##assert_select:特定のHTMLタグが存在するかテストする
    #この場合titleタグが存在していて、タイトルが下記の様に表示されているか検証
    assert_select "title", "Help|#{@base_title}"
  end

  #aboutアクションに対するテスト
  test "should get about" do
    ##static_pages_aboutにアクセスすると成功するはず
    #アクセスできればGreen出来なければRed
    #get static_pages_about_url
    get about_url
    assert_response :success
    ##assert_select:特定のHTMLタグが存在するかテストする
    #この場合titleタグが存在していて、タイトルが下記の様に表示されているか検証
    assert_select "title", "About|#{@base_title}"
  end

  #contactアクションに対するテスト
  test "should get contact" do
    get contact_url
    assert_response :success
    assert_select "title", "Contact|#{@base_title}"
  end

end
