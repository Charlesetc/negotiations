require 'spec_helper'

describe TabsController do

  describe "GET 'admin'" do
    it "returns http success" do
      get 'admin'
      response.should be_success
    end
  end

  describe "GET 'background'" do
    it "returns http success" do
      get 'background'
      response.should be_success
    end
  end

  describe "GET 'chat'" do
    it "returns http success" do
      get 'chat'
      response.should be_success
    end
  end

  describe "GET 'supervisor'" do
    it "returns http success" do
      get 'supervisor'
      response.should be_success
    end
  end

end
