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
  
  # describe 'ユーザー更新機能' do
  #   before do
  #     click_button '登録'
  #     find('.my-account').click
  #     click_link '編集'
  #   end
    
    # it 'ユーザー情報の更新ページが表示される' do
    #   expect(page).to have_selector 'h1', text: 'ユーザー情報の更新'
  #   # end
  # end
  
end 