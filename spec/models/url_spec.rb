require 'rails_helper'

RSpec.describe Url, type: :model do
  let!(:url) { FactoryGirl.create(:url) }

  describe "validations" do
    it { should validate_presence_of(:url) }
    it { should validate_uniqueness_of(:url) }
    it { should validate_uniqueness_of(:id) }
  end

  describe "#smart_add_url_protocol" do
    it "should add http protocal to strings lacking it" do
      expect(url.url).to include('https://')
    end

    it "should not change urls with correct protocal" do
      url = 'https://www.test.com'
      example = Url.create(url: url)
      expect(example.url).to eq(url)

      url2 = 'http://www.test.com'
      example2 = Url.create(url: url2)
      expect(example2.url).to eq(url2)
    end
  end
end
