require 'rails_helper'

describe 'Post機能' , type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let!(:user_b) { FactoryBot.create(:user) }
  let(:reply_content) { Faker::Lorem.sentence(word_count: 30) }
  let(:reply_content_b) { Faker::Lorem.sentence(word_count: 30) }

  
  before 'ログイン後リプライを投稿' do
    visit login_path
    fill_in 'メールアドレス', with: "#{user.email}"
    fill_in 'パスワード', with: 'password'
    check 'ログイン状態を保存'
    click_button 'ログイン'
    visit post_path(user_b.posts.first)
    fill_in '本文', with: reply_content
    click_button '投稿'
  end
  
  describe 'Reply投稿機能' do

    it 'フォームが表示される'do
      expect(page).to have_selector 'form.new_post'
    end
    
    it '投稿成功アラートが表示される' do
      expect(page).to have_selector '.alert', text: "リプライを投稿しました。"
    end
    
    it 'リプライが画面に表示される' do
      expect(page).to have_content reply_content
    end
    
    it 'リプライ元の画面が表示される' do
      expect(page).to     have_content user_b.posts.first.content
      expect(page).not_to have_content user_b.posts.second.content
    end
    
    it 'トップ画面にはリプライが表示されていない' do
      visit user_path(user_b)
      expect(page).not_to have_content reply_content
    end
  end
  
  describe 'リプライ編集機能' do
    before do
      find('.reply-dropdown').click
      click_link '編集'
    end
    
    it 'フォームが正しく表示されている' do
      expect(page).not_to have_selector 'textarea.title'
      expect(page).to     have_selector 'textarea.content'
      expect(page).to     have_selector '#post_picture'
      expect(page).not_to have_selector '.time-form'
    end
    
    context '編集が成功する' do
      before do
        find(".content").set(reply_content_b)
        click_button '編集'
      end
      
      it '成功アラートが表示される' do
        expect(page).to have_selector '.alert', text: '編集が完了しました。'
      end
      
      it '編集前のリプライが削除され、編集後のリプライが表示される' do
        expect(page).not_to have_content reply_content
        expect(page).to     have_content reply_content_b
      end
      
      it 'リプライ元の画面が表示される' do
        expect(page).to     have_content user_b.posts.first.content
        expect(page).not_to have_content user_b.posts.second.content
      end
    end
    
    context '編集が失敗する' do
      before do
        find(".content").set(' ')
        click_button '編集'
      end
      
      it '失敗アラートが表示される' do
        expect(page).to have_selector '.alert', text: '編集が失敗しました。'
        expect(page).to have_selector '.alert', text: '本文を入力してください'
      end
      
      it 'リプライ編集画面が表示される' do
        expect(page).not_to have_selector 'textarea.title'
        expect(page).to     have_selector 'textarea.content'
        expect(page).to     have_selector '#post_picture'
        expect(page).not_to have_selector '.time-form'
      end
      
      it '再読み込みするとリプライ元にリダイレクトされる（リプライのshow画面が表示されない）' do
        visit current_path
        expect(page).to     have_content user_b.posts.first.content
        expect(page).not_to have_content user_b.posts.second.content
        expect(page).to     have_content reply_content
      end
    end
  end
  
  describe 'リプライ削除機能' do
    before do
      find('.reply-dropdown').click
      click_link '削除'
    end
    
    it 'confirmが表示される' do
      expect(page.driver.browser.switch_to.alert.text).to eq "本当にこの投稿を削除しますか？"
    end
      
      context 'confirmにOKする' do
        before do
          page.accept_confirm
        end
        
        it '成功アラートが表示される' do
          expect(page).to have_selector '.alert', text: '投稿を削除しました。'
        end
        
        it 'リプライが削除される' do
          expect(page).not_to have_content reply_content
        end
        
        it 'リプライ元のshow画面が表示される' do
          expect(page).to     have_content user_b.posts.first.content
          expect(page).not_to have_content user_b.posts.second.content
        end
      end
  end
  
  context '別ユーザーからの操作の場合' do
    
    before 'ログイン後リプライを投稿' do
      visit root_path
      find('.dropdown-toggle').click
      click_link href: logout_path
      visit login_path
      fill_in 'メールアドレス', with: "#{user_b.email}"
      fill_in 'パスワード', with: 'password'
      check 'ログイン状態を保存'
      click_button 'ログイン'
      visit post_path(user_b.posts.first)
    end
    
    it 'userからのリプライが表示されている' do
      expect(page).to have_content reply_content
    end
    
    it '他人のdropdownが表示されていない' do
      expect(page).not_to have_selector '.reply-dropdown'
    end
    
    describe '編集' do
      context 'Post_show画面からの編集' do
        before do
          find('.post-dropdown').click
          click_link '編集'
        end
        
        it '正しいフォームが表示される' do
          expect(page).to have_selector 'textarea.title'
          expect(page).to have_selector 'textarea.content'
          expect(page).to have_selector '#post_picture'
          expect(page).to have_selector '.time-form'
        end
        
        it '編集が成功するとPost_show画面にリダイレクトされる' do
          find(".content").set(reply_content_b)
          click_button '編集'
          expect(page).to     have_content reply_content_b
          expect(page).not_to have_content user_b.posts.second.content
        end
      end
    end
    
    context 'リプライ元を削除した場合' do
      before do
        find('.post-dropdown').click
        click_link '削除'
        page.accept_confirm
      end
      
      it '成功アラートが表示され、画面が表示される。' do
        expect(page).to have_selector '.alert', text: '投稿を削除しました。'
        expect(page).to have_content user_b.name
      end
    end
    
  end
  
end
