# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

fruit = ['apple', 'orange', 'grape', 'plum', 'peach']
colors = ['red', 'yellow', 'blue', 'purple', 'rainbow']

Scenario.destroy_all
Negotiation.destroy_all
User.destroy_all

@scenario = Scenario.create(
	general: 'This is general information.',
	first_role: 'You are the first role.',
	second_role: 'You are the second role',
	title: "Main Scenario",
	language: "English"
)

5.times do |i|
	
	@negotiation = @scenario.negotiations.create(
		secure_key: "key_#{i}"
	)
	
	@user = User.create(
		username: colors[i] + fruit[i],
		name: colors[i].capitalize + ' ' + fruit[i].capitalize,
		email: colors[i] + fruit[i] + '@uchicago.edu',
		password: 'foobar',
		password_confirmation: 'foobar',
		sex: 'male',
		age: 12,
		secure_key: "key_#{i}"
	)
	
end