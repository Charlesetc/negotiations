# Place all the behaviors and hooks related to the matching controller here.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


<% url = Negotiations::Application.routes.url_helpers %>



PrivatePub.subscribe "/negotiation/admin/<%= @negotiation_id %>/new", (data, channel) ->
	first_user_id = data.first_user_id
	sender_id = data.sender_id
	unless first_user_id == sender_id
		message = "<p><span>#{data.sender_username }:#{sender_id}>> </span>#{data.content}</p>"
	else
		message = "<p>#{data.sender_username}:#{sender_id}>> #{data.content}</p>"
	$("#message_history").append message

