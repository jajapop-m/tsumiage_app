require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'アカウント有効化' do
    let(:user) { User.new(name: 'テストユーザー',
                      email: 'test@example.com',
                      password: 'password',
                      password_confirmation: 'password') }
    
    it '新規登録時にはアクティベートされていない' do
      expect(user.activated?).to be_falsey
    end
  end
end