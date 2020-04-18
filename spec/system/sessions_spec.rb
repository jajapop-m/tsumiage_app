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
      fill_in 'メールアドレス', with: "#{user.email}"
      fill_in 'パスワード', with: 'password'
      check 'ログイン状態を保存'
      click_button 'ログイン'
    end

    subject{ page }

    it 'ログインが成功したときのレイアウト' do
      is_expected.to have_selector '.alert', text: '成功'
      is_expected.to have_css '.dropdown-toggle'
      is_expected.to have_no_link href: login_path
    end
    
    it 'ログイン後ログアウトしたときのレイアウト' do
      find('.dropdown-toggle').click
      click_link href: logout_path
      is_expected.to have_content 'ログアウトしました'
    end
  end
end
