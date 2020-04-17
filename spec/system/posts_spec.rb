require 'rails_helper'
include SessionsHelper

describe 'Post投稿機能' do
  context '投稿が成功する場合' do
    let!(:user) { FactoryBot.create(:user, email: "test1@example.com") }
    let(:time) { '前に投稿' }
    let(:alert) { '投稿が完了しました。' }
    
    before 'ログイン後user詳細画面を表示' do
      visit login_path
      fill_in 'メールアドレス', with: 'test1@example.com'
      fill_in 'パスワード', with: 'password'
      check 'ログイン状態を保存'
      click_button 'ログイン'
      visit user_path(user)
    end
    
    context 'user画面で投稿ボタンが押された場合' do
      let(:title_1) { '1.テスト題名' }
      let(:content_1) { '1.テストテキストを入力' }
      
      before do
        find(".title").set(title_1)
        find(".content").set(content_1)
        find(".post_request").click
      end
    
      it '投稿成功アラートが表示される' do
        expect(page).to have_content alert
      end
      
      it '投稿が表示されている。' do
        expect(page).to have_content user.name
        expect(page).to have_content title_1
        expect(page).to have_content content_1
        expect(page).to have_content time
      end
      
      describe '画面遷移機能' do
        let(:title_2) { '2.テスト題名' }
        let(:content_2) { '2.テストテキストを入力。' }
        
        before do
          find(".title").set(title_2)
          find(".content").set(content_2)
          find(".expansion").click
        end
        
        it '正常にuser画面からpost画面への画面遷移ができている' do
          expect(page).to have_content title_2
          expect(page).to have_content content_2
        end
        
        it '正常にpost画面からuser画面への画面遷移ができている' do
          find(".reduction").click
          expect(page).to have_content title_2
          expect(page).to have_content content_2
        end
      end
    
      context 'post画面での投稿ボタンが押された場合' do
        let(:title_3) { '3.テスト題名' }
        let(:content_3) { '3.テストタイトルを入力' }
        
        before do
          find(".title").set(title_3)
          find(".content").set(content_3)
          find(".expansion").click
          find(".post_request").click
        end
        
        it '投稿成功アラートが表示される' do
          expect(page).to have_content alert
        end
        
        it '投稿が表示されている。' do
          expect(page).to have_content user.name
          expect(page).to have_content title_3
          expect(page).to have_content content_3
          expect(page).to have_content time
        end
      end
    end
    
    describe '無題の投稿' do
      let(:title_emp) { '　' }
      let(:content_4) { '4.テストタイトルを入力' }
      
      before do
        find(".title").set(title_emp)
        find(".content").set(content_4)
        find(".post_request").click
      end
      
      it 'タイトルが無題に変更される' do
        expect(page).to have_content '無題'
      end
    end
    
    describe 'タイトルのみの投稿' do
      let(:title_5) { '5.テストタイトル' }
      let(:content_emp) { '　' }
      
      before do
        find(".title").set(title_5)
        find(".content").set(content_emp)
        find(".post_request").click
      end
      
      it '本文がby user.nameに変更される' do
        expect(page).to have_content "by #{user.name}"
      end
    end
    
    describe '画像投稿機能' do
      let(:title_6) { '6.テストタイトル' }
      let(:content_6) { '6.テストタイトルを入力' }
      let(:post_id) { "post-#{user.posts.last.id}" }
      
      before do
        find(".title").set(title_6)
        find(".content").set(content_6)
        attach_file "picture", "#{Rails.root}/spec/fixtures/test.jpg"
        find(".post_request").click
      end
      
      it '画像投稿が成功し表示される' do
        expect(find_by_id(post_id)).to have_selector 'img'
      end
    end
    
  end
  
end