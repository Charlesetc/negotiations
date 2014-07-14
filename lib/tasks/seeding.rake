
desc "Perfect for getting things started in production"
task :seed => :environment do
	Scenario.destroy_all
	Negotiation.destroy_all
	User.destroy_all
	Message.destroy_all
	
	@scenario = Scenario.create(
		general: 'Admin Scenario',
		first_role: 'Admin',
		second_role: 'Admin',
		title: "Admin",
		language: "English"
	)
	
	@negotiation = @scenario.negotiations.create(
		secure_key: "key"
	)
	
	@user = User.create(
		username: 'admin',
		name: 'Admin',
		email: 'admin@uchicago.edu',
		password: 'password',
		password_confirmation: 'password',
		sex: 'male',
		age: 25,
		secure_key: "key"
	)
	
	
end