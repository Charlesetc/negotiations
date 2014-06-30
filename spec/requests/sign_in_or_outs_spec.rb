require 'spec_helper'

include ApplicationHelper

describe "Authentication" do
	
	subject { page }

	describe "log in page" do
		before { visit log_in_path }
		
		it { should have_selector('h1', text: 'Log In') }
		it { should have_selector('title', text: 'Log In') }
	end
	
	describe "log in" do
		before { visit log_in_path }
		
		describe "with invalid information" do
			before { click_button 'Enter the Madness' }
			
			it { should have_selector('title', text: 'Log In') }
			it { should have_selector('div.flash-warning') }
			
			describe "after visiting another page" do
				before { visit root_path }
				
				it { should_not have_selector('div.flash-warning') }
			end
		end
		
		describe "with valid information" do # The bug's here
			let(:user) { FactoryGirl.create(:user) }
			before do
				fill_in :email, with: user.email.upcase
				fill_in :password, with: user.password
				click_button 'Enter the Madness'
			end
			
			
					## None of these tests worked properly ##
					##    I remade them using Cucumber.    ##
			
			#it { should have_selector('title', text:  title_helper(user.title)) } # error?
			#it { should have_link('Profile', href: user_path(user)) }
			#it { should have_link('Log Out', href: log_out_path) }
			#it { should_not have_link('Log In', href: log_in_path) }
			#
			#describe 'after saving user' do
			#	
			#	before { user.save }
			#	
			#	it { should have_link 'Sign out' }
			#		
			#		describe 'after logging out' do
			#			
			#			before { click_link 'Log Out' }
			#			
			#			it { should have_link 'Log In' }
			#			
			#		end
			#
			#end
			
		end
		
	end
	
end
