
Given /^a user visits the log in page$/ do
	visit log_in_path
end

When /^they submit invalid log in information$/ do
	click_button 'Submit'
end

Then /^they should see an error message$/ do 
	page.should have_selector 'div.flash-warning'
end

And /^the user has an account$/ do
	@user = User.create!(username: 'nimbostratus',
												email: 'nimbo@strat.us',
												name: 'The Best of Clouds',
												password: 'foobar',
												password_confirmation: 'foobar',
												secure_key: 'key',
												sex: 'male',
												date_of_birth: Time.now - 200000)
end

When /^they submit valid log in information$/ do
	fill_in 'Email', with: @user.email
	fill_in 'Password', with: @user.password
	
	click_button 'Submit'
end

Then /^they should be taken to the instructions page$/ do
	page.should have_selector "title", text: 'Negotiations — Consent'
end

And /^they should see a log out link$/ do
	page.should have_link "Log Out"
end
