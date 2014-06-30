require 'spec_helper'
include ApplicationHelper

describe "User Pages" do
	
	subject { page }

	describe "sign up page" do 
		before { visit signup_path }
		
		it { should have_selector("h1", text: 'Sign Up') }
		it { should have_selector("title", text: title_helper('Sign Up')) }	
		
	end
		
	describe 'sign up link' do
		
		it 'should direct to the sign up page' do
			
			visit root_path
			
			click_link("Jump start your life.")
			
			page.should have_content "Sign Up"
			
		end
		
	end
	
	describe "displaying a user page" do
		
		let(:user) { FactoryGirl.create(:user) }
		
		before { visit user_path(user) }
		
		it { should have_selector('h1', text: user.title) }
		
		it { should have_selector('title', text: title_helper(user.title)) }
		
		
	end
	
	describe 'Sign Up' do
		
		before { visit signup_path }
		
		let(:submit) { "Jump Start" }
		
		describe "with invalid information" do
			it "should not change the user count" do
				expect { click_button submit }.not_to change(User, :count)
			end
		end
		
		describe "with valid information" do
			
			before do
				fill_in 'Username', with: "exampleu"
				fill_in 'Blog Title', with: 'my first blog!'
				fill_in 'Email', with: 'example@blog.edu'
				fill_in 'Password', with: 'foobar'
				fill_in 'Confirmation', with: 'foobar'
			end
			
			it "should change the user count" do
				expect { click_button submit }.to change(User, :count).by(1)
			end
			
		end
		
		
	end
	
end