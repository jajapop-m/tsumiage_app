require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  after(:all) do
    ActionMailer::Base.deliveries.clear
  end

  describe "account_activation" do
    let!(:user) { FactoryBot.create(:user) }
    let(:mail) { UserMailer.account_activation(user) }

    it "renders the headers" do
      expect(mail.subject).to eq("[Tsumiage]メールアドレス確認のお願い")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["noreply@tsumiage.com"])
    end

    # it "renders the body" do
    #   expect(mail.body.encoded).to match("44Oh44O844Or44Ki44OJ44Os44K544Gu56K66KqN") #"メールアドレスの確認"
    # end
  end

  describe "password_reset" do
    let!(:user) { FactoryBot.create(:user) }
    let(:mail) { UserMailer.password_reset(user) }

    it "renders the headers" do
      user.create_reset_digest
      expect(mail.subject).to eq("[Tsumiage]パスワード変更")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["noreply@tsumiage.com"])
    end

    # it "renders the body" do
    #   user.create_reset_digest
    #   expect(mail.body).to match(edit_password_reset_path(user.reset_token, email: user.email) )
    # end
  end

end
