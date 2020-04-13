require 'rails_helper'
include SessionsHelper

describe 'ログイン-ログアウト機能' do
  let!(:user) { FactoryBot.create(:user) }
  
  before do
    visit login_path
  end

  context 'ログインが失敗する場合' do
    before do
      fill_in 'メールアドレス', with: ''
      fill_in 'パスワード', with: ''
      click_button 'ログイン'
    end

    subject{ page }

    it 'リンクが未ログイン時のものになっている' do
      is_expected.to have_link href: login_path
      is_expected.to have_no_link href: user_path(user)
    end

    it 'アラートメッセージが出る' do
      is_expected.to have_selector('.alert-danger',text: '失敗' )
    end

    it 'アラートメッセージが消える' do
      visit root_path
      is_expected.not_to have_selector('.alert-danger',text: '失敗')
    end
  end

  describe 'sessionログイン機能' do
      
    before do
      fill_in 'メールアドレス', with: 'test1@example.com'
      fill_in 'パスワード', with: 'password'
      check 'ログイン状態を保存する'
      click_button 'ログイン'
    end

    subject{ page }

    it 'ログインが成功したときのレイアウト' do
      is_expected.to have_content '成功'
      is_expected.to have_button 'My Account'
      is_expected.to have_no_link href: login_path
    end
  end
end
