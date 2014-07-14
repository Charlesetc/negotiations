
Feature: Logging In

	Scenario: Unsuccessful Log In
		Given a user visits the log in page
		When they submit invalid log in information
		Then they should see an error message
		
	Scenario: Successful Log In
		Given a user visits the log in page
			And the user has an account
		When they submit valid log in information
		Then they should see their profile page
			And they should see a log out link
		
		
