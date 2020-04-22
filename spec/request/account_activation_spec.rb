require 'rails_helper'

RSpec.describe 'Account Activation controller', type: :request do

  describe 'アクティベーション' do
    let!(:user_a) { FactoryBot.create(:user, activated: false) }
    
    context 'アクティベーションが成功する' do
      before do
        get edit_account_activation_path(user_a.activation_token, email: user_a.email)
      end
      
      it '正しいアクティベートURLにアクセスしてアクティベートされる' do
        expect(user_a.reload.activated?).to be_truthy
      end
      
      it 'userがログインされ、ユーザー画面が表示される' do
        expect(response).to redirect_to user_path(user_a)
      end
    end
    
    context 'アクティベーションが失敗する' do
      it 'トークンが間違っている' do
        get edit_account_activation_path(User.new_token, email: user_a.email)
        expect(user_a.reload.activated?).to be_falsey
      end
      
      it 'emailが間違っている' do
        get edit_account_activation_path(user_a.activation_token, email: 'wrong@example.com')
        expect(user_a.reload.activated?).to be_falsey
      end
    end
  end
end