require 'rails_helper'

describe 'ユーザー基本機能', type: :system do

  describe 'パスワードリセット機能' do
    let!(:user) { FactoryBot.create(:user) }
    
    before do
      visit root_path
      find('.login').click
      find('.password-reset', text: 'こちら').click
    end
    
    it 'パスワード再設定画面が表示される' do
      expect(page).to have_selector 'h1', text: 'パスワード再設定'
    end
    
    context '正しいメールアドレスが入力されたとき' do
      before  do
        fill_in 'メールアドレス', with: user.email
        click_button '再設定'
      end
      
      it '成功アラートが表示される' do
        expect(page).to have_selector '.alert', text: 'パスワード再発行のメールを送信しました。メールをご確認ください。'
      end
      
      describe 'reset URLにアクセス後' do
        before do
          reset_token = User.new_token
          user.reset_digest = User.digest(reset_token)
          user.reset_sent_at = Time.zone.now
          user.save
          visit edit_password_reset_path(reset_token, email: user.email)
        end
        
        it 'reset URLにアクセスしてパスワード再設定画面が表示される' do
          expect(page).to have_selector 'h1', text: 'パスワードの再設定'
        end
        
        context '期限内に正しいパスワードを入力したとき' do
          before do
            fill_in 'パスワード', with: 'new_password'
            fill_in 'パスワード（確認）', with: 'new_password'
            click_button '登録'
          end
          
          it '成功アラートが表示され、ユーザー画面が表示される' do
            expect(page).to have_selector '.alert', text: 'パスワードを更新しました'
            expect(page).to have_content user.name
          end
        end
        
        context '空白を入力したとき' do
          before do
            fill_in 'パスワード', with: ' '
            fill_in 'パスワード（確認）', with: ' '
            click_button '登録'
          end
          
          it '失敗アラートが表示され、パスワード再設定画面が表示される' do
            expect(page).to have_selector '.alert', text: 'パスワードの更新に失敗しました。'
            expect(page).to have_selector 'h1', text: 'パスワードの再設定'
          end
        end
        
        context '期限切れ後にパスワードを入力したとき' do
          before do
            user.reset_sent_at = 31.minutes.ago
            user.save
            fill_in 'パスワード', with: 'new_password'
            fill_in 'パスワード（確認）', with: 'new_password'
            click_button '登録'
          end
          
          it '失敗アラートが表示され、パスワード再設定画面が表示される' do
            expect(page).to have_selector '.alert', text: 'リンクの有効期限が切れています。'
            expect(page).to have_selector 'h1', text: 'パスワード再設定'
          end
        end
      end
    end
    
    context '登録されていないメールアドレスが入力されたとき' do
      before do
        fill_in 'メールアドレス', with: 'wrong@example.com'
        click_button '再設定'
      end
      
      it 'アラートが表示され、パスワード再設定画面が表示される' do
        expect(page).to have_selector '.alert', text: 'メールアドレスが間違っています。'
        expect(page).to have_selector 'h1', text: 'パスワード再設定'
      end
    end
  end
end