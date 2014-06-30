
Feature: Update

	Scenario: Unsucessful Update
	Given a user has an account
		And the user has logged in
		And the user visits the edit page
	When they submit invalid information
	Then they should see errors
	
	Scenario: Successful Update
	Given a user has an account
		And the user has logged in
		And the user visits the edit page
	When they submit valid information
	Then they should see a success flash
		And they should have new information
		
	Scenario: Malicious Attack
	Given an anonymous user
	When they submit a put request without authorization
	Then they should be asked to log in