# require "rails_helper"

# RSpec.describe UserMailer, type: :mailer do
#   let!(:user) { FactoryBot.create(:user) }
#   describe "account_activation" do
#     let(:mail) { UserMailer.account_activation(user) }

#     it "renders the headers" do
#       expect(mail.subject).to eq("Account activation")
#       expect(mail.to).to eq([user.email])
#       expect(mail.from).to eq(["noreply@tsumiage.com"])
#     end

#     it "renders the body" do
#       expect(mail.body.encoded).to match("メールアドレスの確認")
#     end
#   end

#   describe "password_reset" do
#     let(:mail) { UserMailer.password_reset }

#     it "renders the headers" do
#       expect(mail.subject).to eq("[Tsumiage]メールアドレス確認のお願い")
#       expect(mail.to).to eq([user.email])
#       expect(mail.from).to eq(["noreply@tsumiage.com"])
#     end

#     it "renders the body" do
#       expect(mail.body.encoded).to match("メールアドレスの確認")
#     end
#   end

# end
