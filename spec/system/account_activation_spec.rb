require 'rails_helper'

describe 'Account Activation機能', type: :system do
  let(:user) { FactoryBot.create(:new_user) }

  before do
    activation_token = User.new_token
    user.activation_digest = User.digest(activation_token)
    user.save
    visit edit_account_activation_path(activation_token, email: user.email)
    user.reload
  end
  
  it 'アクティベーションが成功する' do
    expect(user.activated?).to be_truthy
    expect(user.activated_at).to be_truthy
  end
  
  it '成功アラートが表示され、user画面が表示される' do
    expect(page).to have_selector '.alert', text: 'メールアドレスの確認が完了しました。'
    expect(page).to have_content user.name
  end
end