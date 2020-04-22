require 'rails_helper'

describe 'ユーザー基本機能', type: :system do
  let(:user) { User.first }
  before do
    visit signup_path
    fill_in 'ユーザー名', with: 'テストユーザー'
    fill_in 'メールアドレス', with: 'test1@example.com'
    fill_in 'パスワード', with: 'password'
    fill_in 'パスワード（確認）', with: 'password'
  end
  
  describe 'ユーザー登録機能' do
    context 'ユーザー登録成功' do
    
      it 'ユーザー数が１増加する' do
        expect{ click_button '登録' }.to change{ User.count }.by(1)
      end

    end
  
    context 'ユーザー登録失敗' do
      it 'ユーザー名が空欄' do
        fill_in 'ユーザー名', with: ''
        expect{ click_button '登録' }.not_to change{ User.count }
      end
  
      it 'メールアドレスが空欄' do
        fill_in 'メールアドレス', with: ''
        expect{ click_button '登録' }.not_to change{ User.count }
      end
  
      it 'ユーザー名が長い' do
        fill_in 'ユーザー名', with: "a"*51
        expect{ click_button '登録' }.not_to change{ User.count }
      end
  
      it 'メールアドレスが長い' do
        fill_in 'メールアドレス', with: "a"*244+"@example.com"
        expect{ click_button '登録' }.not_to change{ User.count }
      end
  
      it 'メールアドレスが不適' do
        fill_in 'メールアドレス', with: 'aaaaaaa'
        expect{ click_button '登録' }.not_to change{ User.count }
      end
      
      it 'パスワードが空欄' do
        fill_in 'パスワード', with: ''
        expect{ click_button '登録' }.not_to change{ User.count }
      end
  
      it 'パスワードが短い' do
        fill_in 'パスワード', with: 'aaaaa'
        expect{ click_button '登録' }.not_to change{ User.count }
      end
    end
  end
  
  describe 'ユーザー更新機能' do
    let!(:user) { FactoryBot.create(:user) }
    
    before do
      visit root_path
      find('.login').click
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: user.password
      click_button 'ログイン'
      visit user_path(user)
      find('.my-account').click
      click_link '編集'
    end
    
    it 'ユーザー情報の更新ページが表示される' do
      expect(page).to have_selector 'h1', text: 'ユーザー情報の編集'
    end
    
    context '正しい情報が入力された場合' do
      
      it 'ユーザー名が更新される' do
        fill_in 'ユーザー名', with: 'new_user_name'
        click_button '編集'
        user.reload
        expect(user.name).to eq 'new_user_name'
      end
      
      it 'emailが更新される' do
        fill_in 'メールアドレス', with: 'new_email@example.com'
        click_button '編集'
        user.reload
        expect(user.email).to eq 'new_email@example.com'
      end
      
      it 'passwordが更新され、新しいパスワードでログインができる' do
        fill_in 'パスワード', with: 'new_password'
        fill_in 'パスワード（確認）', with: 'new_password'
        click_button '編集'
        user.reload
        find('.my-account').click
        click_link 'ログアウト'
        visit root_path
        find('.login').click
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: 'new_password'
        click_button 'ログイン'
        expect(page).to have_selector '.alert', text: 'ログインが成功しました'
        expect(page).to have_content user.name
      end
    end
    
    context '間違った情報が入力されたとき' do
      
      it 'ユーザー名が空欄のときエラーになる' do
        fill_in 'ユーザー名', with: ''
        click_button '編集'
        user.reload
        expect(page).to have_selector 'h1', text: 'ユーザー情報の編集'
        expect(page).to have_selector '.alert'
      end
      
      it 'emailが空欄のときエラーになる' do
        fill_in 'メールアドレス', with: ''
        click_button '編集'
        user.reload
        expect(page).to have_selector 'h1', text: 'ユーザー情報の編集'
        expect(page).to have_selector '.alert'
      end
    end
  end
  
end 