require 'rails_helper'
include SessionsHelper

describe 'ユーザー登録機能', type: :system do
  before do
    visit signup_path
    fill_in 'ユーザー名', with: 'テストユーザー'
    fill_in 'メールアドレス', with: 'test1@example.com'
    fill_in 'パスワード', with: 'password'
    fill_in 'パスワード（確認）', with: 'password'
  end

  it 'ユーザー登録成功' do
    expect{ click_button '登録' }.to change{ User.count }.by(1)
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

    it 'メールアドレスが重複' do
      FactoryBot.create(:user)
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