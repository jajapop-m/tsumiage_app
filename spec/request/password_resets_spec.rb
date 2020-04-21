require 'rails_helper'

RSpec.describe 'Password Reset controller', type: :request do
  let!(:user) { FactoryBot.create(:user, password: 'password') }

  describe '#new' do
    before do
      get new_password_reset_path
    end
    
    it 'リクエストが成功する' do
      expect(response.status).to eq 200
    end
    
    it 'パスワードリセット画面が表示される' do
      expect(response.body).to include "パスワード再設定"
    end
  end
  
  describe '#edit' do
    
    context '登録済みのメールアドレスが送信されたとき' do
      before do
        post password_resets_path, params: { password_resets: { email: user.email } }
      end
      
      it 'リクエストが成功し、root_urlにリダイレクトされる' do
        expect(response.status).to eq 302
        expect(response).to redirect_to root_url
      end
      
      it 'reset_digest,reset_sent_atが生成されている' do
        user.reload
        expect(user.reset_digest).to be_truthy
        expect(user.reset_sent_at).to be_truthy
      end
    end
    
    context '未登録のメールアドレスが送信されたとき' do
      before do
        post password_resets_path, params: { password_resets: { email: "wrong@example.com" } }
      end
      
      it 'リクエストが成功し、newテンプレートが表示される' do
        expect(response.status).to eq 200
        expect(response.body).to include "メールアドレスが間違っています"
        expect(response.body).to include "パスワード再設定"
      end
    end
  end
  
  # describe '#update' do
  #   before do
  #     token = User.new_token
  #     user.reset_digest = User.digest(token)
  #     patch password_reset_path(token), params: { email: user.email,
  #       user: { password: 'new_password', password_confirmation: 'new_password' } }
  #   end
    
  #   it 'パスワードが更新される' do
  #     user.reload
  #     expect(user.password).to eq 'new_password'
  #   end
  # end
end