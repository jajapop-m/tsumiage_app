require 'rails_helper'
include SessionsHelper

describe 'ログイン機能' do
  before do
    visit login_path
  end

  describe 'ログインが失敗する場合' do
    before do
      fill_in 'メールアドレス', with: ''
      fill_in 'パスワード', with: ''
      click_button 'ログイン'
    end

    subject{ page }

    it 'リンクが未ログイン時のものになっている' do
      is_expected.to have_content 'Log in'
      is_expected.to have_no_content 'Profile'
    end

    it 'アラートメッセージが出る' do
      is_expected.to have_selector('.alert-danger',text: '失敗' )
    end

    it 'アラートメッセージが消える' do
      visit root_path
      is_expected.not_to have_selector('.alert-danger',text: '失敗')
    end
  end

  describe 'sessionログイン' do
    before do
      @user_a = FactoryBot.create(:user)
      fill_in 'メールアドレス', with: 'test1@example.com'
      fill_in 'パスワード', with: 'password'
      click_button 'ログイン'
    end

    subject{ page }

    it 'ログインが成功したときのレイアウト' do
      is_expected.to have_link href: logout_path
      is_expected.to have_link href: user_path(@user_a)
      is_expected.to have_no_link href: login_path
    end
  end
end