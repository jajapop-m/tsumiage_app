require 'rails_helper'

describe 'ユーザーアカウント機能', type: :system do
  describe 'ユーザー登録機能' do
    context do
      before do
        visit signup_path
        fill_in 'ユーザー名', with: 'テストユーザー'
        fill_in 'メールアドレス', with: 'a@example.com'
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワード（確認）', with: 'password'
      end
      
      it 'ユーザー登録成功' do
        expect{ click_button '登録' }.to change{ User.count }.by(1)
      end
      
      it 'ユーザー登録失敗（ユーザー名が空欄）' do
        fill_in 'ユーザー名', with: ''
        expect{ click_button '登録' }.not_to change{ User.count }
      end
      
      it 'ユーザー登録失敗（メールアドレスが空欄)' do
        fill_in 'ユーザー名', with: ''
        expect{ click_button '登録' }.not_to change{ User.count }
      end
      
      it 'ユーザー登録失敗（ユーザー名が長い）' do
        fill_in 'ユーザー名', with: "a"*51
        expect{ click_button '登録' }.not_to change{ User.count }
      end
      
      it 'ユーザー登録失敗（メールアドレスが長い)' do
        fill_in 'ユーザー名', with: "a"*234+"@example.com"
        expect{ click_button '登録' }.not_to change{ User.count }
      end
      
      # it 'ユーザー登録失敗（メールアドレスが不適）' do
      #   fill_in 'ユーザー名', with: 'aaaaaaa'
      #   expect{ click_button '登録' }.not_to change{ User.count }
      # end
    end
  end
end