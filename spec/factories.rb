FactoryGirl.define do
	
	factory :user do
		
		username "Exampleuser"
		email "Example@user.com"
		title "Example Blog"
		password "foobar"
		password_confirmation "foobar"
		
	end
	
end