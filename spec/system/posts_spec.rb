require 'rails_helper'

describe 'Post機能' do
  let!(:user) { FactoryBot.create(:user, email: "test1@example.com") }
  let!(:user_2) { FactoryBot.create(:user) }
  
  before 'ログイン後user詳細画面を表示' do
    visit login_path
    fill_in 'メールアドレス', with: "#{user.email}"
    fill_in 'パスワード', with: 'password'
    check 'ログイン状態を保存'
    click_button 'ログイン'
    visit user_path(user)
  end
  
  context '投稿フォーム' do
    it '自分のページではフォームが表示されている' do
      expect(page).to have_selector 'form#new_post'
    end
    
    it '他人のページではフォームが表示されていない' do
      visit user_path(user_2)
      expect(page).not_to have_selector 'form#new_post'
    end
    
    it '/posts/newでフォームが表示されている' do
      expect(page).to have_selector 'form#new_post'
    end
  end
  
  context '投稿が成功する場合' do
    let(:time) { user.posts.first.created_at.to_s(:published_on) }
    let(:alert) { '投稿が完了しました。' }

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
        expect(page).to have_link user.name
        expect(page).to have_link title_1
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
        expect(page).to have_link user.name
        expect(page).to have_link title_3
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
      let(:post_id) { "post-#{user.posts.first.id}" }
      
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
  
  describe 'Post編集機能' do
    let(:time) { user.posts.first.created_at.to_s(:published_on) }
    let(:alert) { '編集が完了しました。' }
    let(:danger) { '編集が失敗しました。' }
    let(:title_be) { 'テスト題名編集前' }
    let(:title_af) { 'テスト題名編集後'}
    let(:content_be) { 'テストテキスト編集前' }
    let(:content_af) { 'テストテキスト編集後' }
    
    before do
      find(".title").set(title_be)
      find(".content").set(content_be)
      find(".post_request").click
      page.all(".post-dropdown")[0].click
      click_on '編集'
    end
      
    it '編集画面に遷移する' do
      expect(page).to have_content '編集'
    end
    
    context '編集が成功する場合' do
      before do
        find(".title").set(title_af)
        find(".content").set(content_af)
        click_button '編集'
      end
      
      it 'アラートが表示される' do
        expect(page).to have_selector '.alert', text: alert
      end
        
      it '編集した内容が表示される' do
        expect(page).to have_link title_af
        expect(page).to have_content content_af
        expect(page).not_to have_content user.posts.second.content
      end
    end
      
    context '編集が失敗する場合' do
      before do
        find(".title").set("")
        find(".content").set("")
        click_button '編集'
      end
      
      it 'アラートが表示される' do
        expect(page).to have_selector '.alert', text: danger
      end
      
      it '編集画面が表示される' do
        expect(page).to have_content '編集'
      end
    end
  end
  
  describe 'Post削除機能' do
    let(:time) { user.posts.first.created_at.to_s(:published_on) }
    let(:success) { '投稿を削除しました。' }
    let(:title_de) { 'テスト題名destroy' }
    let(:content_de) { 'テストテキストdestroy' }

    before do
      find(".title").set(title_de)
      find(".content").set(content_de)
      find(".post_request").click
    end
    
    context 'User画面のドロップダウンの削除ボタンを押した場合' do
      before do
        page.all(".post-dropdown")[0].click
        click_on '削除'
      end
      
      it 'confirmが表示される' do
        expect(page.driver.browser.switch_to.alert.text).to eq "本当にこの投稿を削除しますか？"
      end
      
      context 'confirmをキャンセルした場合'do
        before do
          page.dismiss_confirm
        end
        
        it 'postが表示される' do
          expect(page).to have_link title_de
          expect(page).to have_content content_de
        end
      end
      
      context 'confirmをOKした場合' do
        before do
          page.accept_confirm
        end
        
        it 'User画面が表示される' do
          expect(page).to have_content user.name
        end
        
        it 'User画面のdropdowonから削除ボタンを押して削除完了アラートが表示される' do
          expect(page).to have_selector '.alert', text: success
        end
        
        it '投稿が削除される' do
          expect(page).not_to have_link title_de
          expect(page).not_to have_content content_de
        end
      end
    end
    
    context 'Post詳細画面の削除ボタンを押した場合' do
      before do
        click_on title_de
        find('.post-dropdown').click
        click_on '削除'
      end
      
      it 'confirmが表示される' do
        expect(page.driver.browser.switch_to.alert.text).to eq "本当にこの投稿を削除しますか？"
      end
      
      context 'confirmをキャンセルした場合'do
        before do
          page.dismiss_confirm
        end
        
        it 'postが表示される' do
          expect(page).to have_link title_de
          expect(page).to have_content content_de
        end
      end
      
      context 'confirmをOKした場合' do
        before do
          page.accept_confirm
        end
        
        it 'User画面が表示される' do
          expect(page).to have_content user.name
        end
        
        it 'User画面のdropdowonから削除ボタンを押して削除完了アラートが表示される' do
          expect(page).to have_selector '.alert', text: success
        end
        
        it '投稿が削除される' do
          expect(page).not_to have_content title_de
          expect(page).not_to have_content content_de
        end
      end
    end
  end
end