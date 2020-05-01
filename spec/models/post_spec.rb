require 'rails_helper'

RSpec.describe Post, type: :model do
  let!(:user){ FactoryBot.create(:user)}
  
  it 'Postモデルが有効' do
    post = Post.new(title: "ポストテスト",
                  content: "コンテンツテスト",
                  user_id: user.id)
    expect(post).to be_valid
  end
  
  describe 'Postモデルが無効' do
    it 'user_idがnil' do
      post = Post.new(title: "ポストテスト",
                  content: "コンテンツテスト",
                  user_id: nil)
      expect(post).not_to be_valid
    end
    
    it 'contentが空欄' do
      post = Post.new(title: "ポストテスト",
                  content: "　",
                  user_id: user.id)
      expect(post).not_to be_valid
    end
    
    it 'titleが長い' do
      post = Post.new(title: "a"*51,
                  content: "コンテンツテスト１",
                  user_id: user.id)
      expect(post).not_to be_valid
    end
  end
end
