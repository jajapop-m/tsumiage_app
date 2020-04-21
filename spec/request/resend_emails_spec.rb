require 'rails_helper'

RSpec.describe 'Resend Emails controller', type: :request do
  
  describe 'メール再送機能（resend_email_controller)' do
    let!(:user_a) { FactoryBot.create(:user, activated: false) }
    let!(:user_un) { FactoryBot.create(:user, activated: true) }
    let!(:digest_a) { user_a.activation_digest }
    let!(:digest_un) { user_un.activation_digest}
    
    context '未アクティブユーザーのメールアドレスの場合' do
      before do
        post resend_emails_path, params: { resend_emails: { email: user_a.email } }
      end
      
      it 'リクエストが成功し、root_urlにリダイレクトされる' do
        expect(response.status).to eq 302
        expect(response).to redirect_to root_url
      end
      
      it 'digestが更新される' do
        user_a.reload
        expect(user_a.activation_digest).not_to eq digest_a
      end
    end
    
    context 'アクティブ済みユーザーのメールアドレスの場合' do
      before do
        post resend_emails_path, params: { resend_emails: { email: user_un.email } }
      end
      
      it 'リクエストが成功し、login_pathにリダイレクトされる' do
        expect(response.status).to eq 302
        expect(response).to redirect_to login_path
      end
      
      it 'digestが更新されない' do
        user_a.reload
        expect(user_un.activation_digest).to eq digest_un
      end
    end
    
    context '登録されていないメールアドレスの場合' do
      before do
        post resend_emails_path, params: { resend_emails: { email: "wrong@example.com" } }
      end
      
      it 'リクエストが成功し、new_pathにレンダーされる' do
        expect(response.status).to eq 200
      end
      
      it 'newテンプレートが表示される' do
        expect(response.body).to include "メールアドレスの確認メールの再送"
      end
      
      it 'digestが更新されない' do
        user_a.reload
        expect(user_un.activation_digest).to eq digest_un
      end
    end
  end
  
end