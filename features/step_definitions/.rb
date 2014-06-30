
Given /^a user visits the log in page$/ do
	visit log_in_path
end

When /^they submit invalid log in information$/ do
	click_button 'Enter the Madness'
end

Then /^they should see an error message$/ do 
	page.should have_selector 'div.flash-warning'
end

And /^the user has an account$/ do
	@user = User.create!(username: 'nimbostratus',
												email: 'nimbo@strat.us',
												title: 'The Best of Clouds',
												password: 'foobar',
												password_confirmation: 'foobar')
end

When /^they submit valid log in information$/ do
	fill_in 'Email', with: @user.email
	fill_in 'Password', with: @user.password
	
	click_button 'Enter the Madness'
end

Then /^they should see their profile page$/ do
	page.should have_selector "title", text: @user.title
end

And /^they should see a log out link$/ do
	page.should have_link "Log Out"
end
