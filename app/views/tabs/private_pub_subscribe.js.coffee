# Place all the behaviors and hooks related to the matching controller here.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


<% url = Negotiations::Application.routes.url_helpers %>



PrivatePub.subscribe "/negotiation/<%= current_user.negotiation.id %>/new", (data, channel) ->
	user_id = $('.etabs').data('id')
	if user_id == data.user_id
		message = "<div class = 'sender_message'>
			<span>#{data.content}</span></div>"
	else
		message = "<div class = 'receiver_message'>
			<span>#{data.content}</span></div>"
	$(".message_index .container").append message
	$('.message_index').scrollTop(900000000)

