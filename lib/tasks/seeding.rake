
desc "Perfect for getting things started in production"
task :seed => :environment do
	Scenario.destroy_all
	Negotiation.destroy_all
	User.destroy_all
	Message.destroy_all
	Agreement.destroy_all
	
	@scenario = Scenario.create(
		general: "Paz is a large oil company that owns many gas stations.",
		first_role: "Paz wants to negotiate sales for them.",
		second_role: "end to your dreams.",
		first_role_title: 'Paz Representative',
		second_role_title: 'Gas Station Owner',
		title: "Admin",
		language: "English"
	)
	
	@negotiation = @scenario.negotiations.create(
		secure_key: "extraordinarily_secure_key"
	)
	
	@user = User.create(
		username: 'charlesetc',
		name: 'Charles',
		email: 'charlesetc@uchicago.edu',
		password: 'cpipin',
		password_confirmation: 'cpipin',
		sex: 'male',
		date_of_birth: Time.now - 100000000,
		secure_key: "key", 
		start_english: '25',
		country: 'usa',
		english_home: true,
		acquired_english: ['from parent'],
		hebrew_listening: 3,
		hebrew_speaking: 3,
		hebrew_reading: 3,
		hebrew_writing: 3,
		english_listening: 3,
		english_speaking: 3,
		english_reading: 3,
		english_writing: 3,
		research: 'Hi there',
		emotions: 'Many.'
	)
	
	@user.update_attribute :admin, true
	
	puts 'Seed successful.'
	puts 'Email: admin@uchicago.edu'
	puts 'Password: foobar'
	
end