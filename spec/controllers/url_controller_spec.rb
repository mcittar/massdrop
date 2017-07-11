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
      before(:each) do
        post :create, params: { url: 'www.hey-arnold.com' }
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
    Sidekiq::Testing.inline! do
      before(:each) do
        url = Url.create(id: 1, url: 'www.google.com')
        HardWorker.perform_async(url.id)
        HardWorker.drain
        get :show, params: { id: 1 }
      end
    end
    it { should respond_with(200) }
    it "should return the requested job job" do
      expect(JSON.parse(response.body)["id"]).to eq(1)
    end
    it "should update status after job completion" do
      expect(JSON.parse(response.body)["status"]).to be true
    end
    it "should retrieve html" do
      expect(JSON.parse(response.body)["html"]).to_not be nil
    end
  end
end
