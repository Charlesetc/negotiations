require 'spec_helper'

describe "Static Pages" do
	
	let(:base_title) {"Maylogs"}
	
	describe "Home Page" do
		
		it "should have the content 'Maylogs'" do
			visit '/static/home'
			page.should have_selector('h1',
			 :text => "Maylogs")
		end
	
		it "should have the right title" do
			visit '/static/home'
			page.should have_selector('title', 
			:text => "#{base_title}")
		end
		
		it "should be the root page" do
			visit root_path
			page.should have_selector('title', 
			:text => "#{base_title}")
			page.should have_selector('h1',
			:text => "Maylogs")
		end
		
	end
	
	describe "Help Page" do

		it "should have the content 'About'" do
			visit '/static/about'
			page.should have_selector('h1',
			 :text => "About")
		end
		
		it "should have the right title" do
			
			visit '/static/about'
			page.should have_selector('title',
			 :text => "#{base_title} — About")
			
		end
		
	end
	
	describe "Reference Page" do

		it "should have the content 'Reference'" do
			visit '/static/reference'
			page.should have_selector('h1',
			 :text => "Reference")
		end
		
		it "should have the right title" do
			
			visit '/static/reference'
			page.should have_selector('title',
			 :text => "#{base_title} — Reference")
			
		end
		
	end
	
end