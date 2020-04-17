require 'rails_helper'

RSpec.describe 'Posts controller', type: :request do
  let!(:user) { FactoryBot.create(:user) }

  describe 'GET #index' do
    context 'ログインしていない場合' do
      before do
        get posts_path
      end
      
      it 'リクエストが成功する' do
        expect(response.status).to eq 302
      end
      
      it 'root_urlにリダイレクトされること' do
        expect(response).to redirect_to root_url
      end
    end
    
    context 'ログインしている場合' do
      before do
        post login_path, params: { session: { email: user.email,
                                      password: user.password,
                                      remember_me: '1'} }
        get posts_path
      end
      
      it 'リクエストが成功する' do
        expect(response.status).to eq 302
      end
      
      it 'current_userにリダイレクトされること' do
        expect(response).to redirect_to user_path(user)
      end
    end
  end
  
  describe 'GET #new' do
    context 'ログインしていない場合' do
      before do
        get new_post_path
      end
      
      it 'リクエストが成功する' do
        expect(response.status).to eq 302
      end
      
      it 'logiin_pathにリダイレクトされること' do
        expect(response).to redirect_to login_url
      end
    end
    
    context 'ログインしている場合' do
      before do
        post login_path, params: { session: { email: user.email,
                                      password: user.password,
                                      remember_me: '1'} }
        get posts_path
      end
      
      it 'リクエストが成功する' do
        expect(response).to redirect_to user_path(user)
      end
    end
  end
  
  describe 'GET #show' do
    it 'リクエストが成功する' do
      post login_path, params: { session: { email: user.email,
                                    password: user.password,
                                    remember_me: '1'} }
      get post_path(user.posts.first)
      expect(response.status).to eq 200
    end
  end

end