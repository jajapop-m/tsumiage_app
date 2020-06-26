require 'rails_helper'

describe 'Time Post機能', type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let(:title) { Faker::Lorem.sentence(word_count: 5) }
  let(:content) { Faker::Lorem.sentence(word_count: 30) }

  before 'ログイン後user詳細画面を表示' do
    visit login_path
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: 'password'
    check 'ログイン状態を保存'
    click_button 'ログイン'
    visit user_path(user)
  end

  it 'time-formが存在している' do
    expect(page).to have_selector '#time_form'
  end

  context 'Startボタンを押す' do
    let!(:time_start) { Time.zone.now.strftime("%m/%d %H:%M") }
    before do
      find('.time-start').click
      @post_id = "post-#{user.posts.first.id}"
    end

    it 'ボタンがENDに変わる' do
      expect(page).to have_selector 'input.time-end'
    end

    it '新しい投稿が投稿される' do
      expect(page).to have_content '新しい投稿'
      expect(page).to have_content user.name
      expect(page).to have_content time_start
    end

    context 'タイムポストを編集する' do
      before do
        find_by_id(@post_id).find('.post-dropdown').click
        click_link '編集'
        find('.title').set(title)
        find('.content').set(content)
        click_on '編集'
        visit user
      end

      it '編集が完了する' do
        expect(find_by_id(@post_id)).to have_content title
        expect(find_by_id(@post_id)).to have_content content
        expect(find_by_id(@post_id)).to have_content time_start
      end

      context 'ENDボタンを押す' do
        let(:time_end) { Time.zone.now.strftime("%H:%M") }
        before { find('.time-end').click }

        it '投稿が更新され、終了時間が表示される' do
          expect(find_by_id(@post_id)).to have_content title
          expect(find_by_id(@post_id)).to have_content content
          expect(find_by_id(@post_id)).to have_content time_start
          expect(find_by_id(@post_id)).to have_content time_end
        end
      end

    end
  end



end
