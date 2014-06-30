
# Unsuccessful Update Scenario  # This doesn't work because I don't know how to sign in

Given /^a user has an account$/ do
	@user = User.create!(username: 'nimbostratus',
												email: 'nimbo@strat.us',
												title: 'The Best of Clouds',
												password: 'foobar',
												password_confirmation: 'foobar')
end

And /^the user has logged in$/ do
	visit log_in_path
	fill_in 'Email', with: @user.email
	fill_in 'Password', with: @user.password
	click_on 'Enter the Madness'
end


And /^the user visits the edit page$/ do
	visit edit_user_path(@user)
end

When /^they submit invalid information$/ do
	click_on 'Change Identity'
end

Then /^they should see errors$/ do 
	page.should have_selector 'div#error_log'
end



# Successful Update Scenario  # This doesn't work, because I don't know how to sign in

When /^they submit valid information$/ do
	fill_in 'Email', with: @user.email
	fill_in 'Password', with: @user.password
	fill_in 'Title', with: @user.title
	fill_in 'Confirmation', with: @user.password_confirmation
	fill_in 'Username', with: 'newusername'
	
	click_button 'Change Identity'
end

Then /^they should see a success flash$/ do
	page.should have_selector 'div.flash-success'
end

And /^they should have new information$/ do
	user = User.find_by_email(@user.email)
	expect(user.username).to satisfy { |v| v == 'newusername' }
end


# Malicious Attack Scenario  # This doesn't work, but should

Given /^an anonymous user$/ do
	@existing_user = User.create!(username: 'username', email: 'e@ma.il', 
	title: 'Title', password: 'password', password_confirmation: 'password')
end

When /^they submit a put request without authorization$/ do
	visit edit_user_path(@existing_user)
end

Then /^they should be asked to log in$/ do
	page.should have_selector "section#log_in"
end