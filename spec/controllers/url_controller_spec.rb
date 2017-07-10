require 'rails_helper'

RSpec.describe UrlController, type: :controller do
  render_views

  describe "POST #create" do
    context "with invalid params" do
      Sidekiq::Testing.inline! do
        before(:each) do
          post :create
        end
      end
      it { should respond_with(422) }
      it 'should not create the url' do
        expect(Url.exists?).to be false
      end
    end

    context "with valid params" do
      Sidekiq::Testing.inline! do
        before(:each) do
          post :create, params: { url: 'www.hey-arnold.com' }
        end
      end
      it { should respond_with(200) }
      it "should return job ID" do
        expect(response.body).to include("id")
      end
      it 'should save the url' do
        expect(Url.exists?).to be true
      end

    end
  end

  describe "GET #show" do

  end
end
