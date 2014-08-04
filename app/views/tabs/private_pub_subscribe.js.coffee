# Place all the behaviors and hooks related to the matching controller here.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


<% url = Negotiations::Application.routes.url_helpers %>



PrivatePub.subscribe "/negotiation/<%= current_user.negotiation.id %>/new", (data, channel) ->
	user_id = Number(CURRENT_USER_ID)
	sender_id = Number(data.sender_id)
	# alert "#{user_id} - #{JSON.stringify data} - #{user_id == sender_id}"
	if data.accept_alert_request
		window.location = "/agreement"
	else if data.deny_alert_request
		unless user_id == sender_id
			$(".agreement_waiting").remove()
			$('.agreement_button').removeClass 'disabled'
			alert 'The other participant is not yet ready to fill out the agreement form.'
	else if data.alert_request
		unless user_id == sender_id
			if confirm 'The other participant has requested to continue 
			to the agreement form. Are you ready?'
				$.post 'users/accept_alert_request', {
					authenticity_token: AUTH_TOKEN,
					tactic: 'accept'
				}
			else
				$.post 'users/accept_alert_request', {
					authenticity_token: AUTH_TOKEN,
					tactic: 'deny'
				}
	else if data.typing
		unless user_id == sender_id # something's funky
			unless $('.typing').length > 0
				typing = "<div class = 'typing'><div></div>
		  		 	   		<div class = 'typing_two'></div>
							<div class = 'typing_three'></div>
	 						</div>"
				$('.message_index').append typing
				$('.message_index').scrollTop(900000000)
				$('.typing div').css 'animation', 'typing 2s infinite'
				$('.typing .typing_two').css 'animation-delay', '-0.3s'
				$('.typing .typing_three').css 'animation-delay', '-0.6s'
	else if data.not_typing
		unless user_id == sender_id		
			$('.typing').remove()
	else
		if user_id == sender_id
			message = "<div class = 'sender_message'>
				<span>#{data.content}</span></div>"
		else
			message = "<div class = 'receiver_message'>
				<span>#{data.content}</span></div>"
		$(".message_index .container").append message
		$('.message_index').scrollTop(900000000)
		$('.typing').remove()
				
				


