# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

fruit = ['apple', 'orange', 'grape', 'plum', 'peach']
colors = ['red', 'yellow', 'blue', 'purple', 'rainbow']
words = ['sea', 'river', 'pond', 'air', 'fire']

Scenario.destroy_all
Negotiation.destroy_all
User.destroy_all
Message.destroy_all

@scenario = Scenario.create(
	general: 'This is general information.',
	first_role: 'You are the first role.',
	second_role: 'You are the second role',
	title: "Main Scenario",
	language: "English"
)

@scenario_two = Scenario.create(
	general: 'This is other general information.',
	first_role: 'You are the first primary role.',
	second_role: 'You are the second secondary role',
	title: "Main Scenario",
	language: "English"
)


5.times do |i|
	
	@negotiation = @scenario.negotiations.create(
		secure_key: "key_#{i}"
	)
	

	@negotiation_two = @scenario_two.negotiations.create(
			secure_key: "secure_key_#{i}"
		)
	
	@user = User.create(
		username: colors[i] + fruit[i],
		name: colors[i].capitalize + ' ' + fruit[i].capitalize,
		email: colors[i] + fruit[i] + '@uchicago.edu',
		password: 'foobar',
		password_confirmation: 'foobar',
		sex: 'male',
		date_of_birth: Time.now,
		secure_key: "key_#{i}",
		research: "Yep hello",
		emotions: 'Sad, angry'
	)
	
	if i == 0
		@user = User.create(
			username: 'greenkiwi',
			name: 'Green Kiwi',
			email: 'greenkiwi' + '@uchicago.edu',
			password: 'foobar',
			password_confirmation: 'foobar',
			sex: 'female',
			date_of_birth: Time.now,
			secure_key: "key_#{i}",
			research: "Yep hello",
			emotions: 'Sad, angry'
		)
	end
	
	@user_two = User.create(
		username: colors[i] + words[i],
		name: colors[i].capitalize + ' ' + words[i].capitalize,
		email: colors[i] + words[i] + '@uchicago.edu',
		password: 'foobar',
		password_confirmation: 'foobar',
		sex: 'male',
		date_of_birth: Time.now,
		secure_key: "secure_key_#{i}",
		research: "Yep hello",
		emotions: 'Sad, angry'
	)
	
	@user_three = User.create(
		username: words[i] + colors[i],
		name: words[i].capitalize + ' ' + colors[i].capitalize,
		email: words[i] + colors[i] + '@uchicago.edu',
		password: 'foobar',
		password_confirmation: 'foobar',
		sex: 'female',
		date_of_birth: Time.now,
		secure_key: "secure_key_#{i}",
		research: "Yep hello",
		emotions: 'Sad, angry'
	)
	
end
#
# User.find_by_email('rainbowpeach@uchicago.edu').update_attribute(:admin, true)