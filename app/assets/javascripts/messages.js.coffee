# Javascript for messages

position_footer = -> 
	if $(document).height() > $(window).height()
		$('footer').removeClass 'fixed_footer'
	else 
		$('footer').addClass 'fixed_footer'

$ ->
	$('.message_content').keypress (e) ->
		position_footer()
		if e.which == 13
			content = $('.message_content').val()
			$('.message_content').val('').change()
			$.post "/create_message", {
				authenticity_token: AUTH_TOKEN, 
				content: content,
				sender_id: CURRENT_USER_ID
			}
			
			return false
			
	# $('.message_content').click ->
	# 	$.post "/misc_negotiation", {
	# 		authenticity_token: AUTH_TOKEN,
	# 		typing: true,
	# 		sender_id: CURRENT_USER_ID
	# 	}
	#
	# $('.message_content').blur ->
	# 	$.post "/misc_negotiation", {
	# 		authenticity_token: AUTH_TOKEN,
	# 		not_typing: true,
	# 		sender_id: CURRENT_USER_ID
	# 	}