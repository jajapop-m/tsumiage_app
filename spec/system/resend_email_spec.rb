require 'rails_helper'

describe 'resend_email機能', type: :system do
  let!(:user) { FactoryBot.create(:user, activated: false, activated_at: nil) }
  let!(:activated_user) { FactoryBot.create(:user, activated: true) }
  
  describe '#new' do
    before do
      visit root_path
    end
    
    it 'signup画面からnew画面が表示される' do
      find('.signup-button').click
      find('.resend-email').click
      expect(page).to have_selector 'h1', text: 'メールアドレスの確認メールの再送'
    end
    
    it 'login画面からnew画面が表示される' do
      find('.login-button').click
      find('.resend-email').click
      expect(page).to have_selector 'h1', text: 'メールアドレスの確認メールの再送'
    end
  end
  
  describe '#create' do
    before do
      visit root_path
      find('.signup-button').click
      find('.resend-email').click
    end

    context 'activateされていないユーザーの場合' do
      before do
        fill_in 'メールアドレス', with: user.email
        click_button '再送'
      end
      
      it '成功アラートが表示される' do
        expect(page).to have_selector '.alert', text: '確認メールを再送しました'
      end
      
      it 'activation_digestが再発行されている' do
        expect(user.activation_digest).not_to eq user.reload.activation_digest
      end
    end
    
    context 'activateされたユーザーの場合' do
      before do
        fill_in 'メールアドレス', with: activated_user.email
        click_button '再送'
      end
      
      it '失敗アラートが表示され、login_pathが表示される' do
        expect(page).to have_selector '.alert', text: 'すでにメールアドレスの確認済みです。ログインしてください。'
        expect(page).to have_selector 'h1', text: 'ログイン'
      end
      
      it 'activation_digestが再発行されていない' do
        expect(user.activation_digest).to eq user.reload.activation_digest
      end
    end
    
    context 'emailからユーザーを見つけられない場合' do
      before do
        fill_in 'メールアドレス', with: 'wrong@example.com'
        click_button '再送'
      end
      
      it '失敗アラートが表示され、new画面が表示される' do
        expect(page).to have_selector '.alert', text: '登録済みのメールアドレスを入力してください'
       expect(page).to have_selector 'h1', text: 'メールアドレスの確認メールの再送'
      end
      
      it 'activation_digestが再発行されていない' do
        expect(user.activation_digest).to eq user.reload.activation_digest
      end
    end
    
  end
  
  
end