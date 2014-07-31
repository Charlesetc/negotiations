# Place all the behaviors and hooks related to the matching controller here.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


<% url = Negotiations::Application.routes.url_helpers %>

user_id = <%= current_user.id %>

size_stop = -> # Changes should be copied too.
	difference = -40
	if $('#sender_page').height() > $('#receiver_page').height()
		height = $('#sender_page').height() + difference
		if height > ($(window).height() * 0.45)
			$('#stop_receiver').height(height)
		else
			$('#stop_receiver').height(($(window).height() * 0.45))
	else
		height = $('#receiver_page').height() + difference
		if height > $(window).height() * 0.45
			$('#stop_receiver').height(height)
		else
			$('#stop_receiver').height(($(window).height() * 0.45))
			
save_form = ->
	agreement_boolean = $('.agreement_boolean').val()
	agreement_price = $('#agreement_price').val()
	if agreement_boolean == 'true'
		agreement_description = $('#agreement_content_yes').val()
	else
		agreement_description = $('#agreement_content_no').val()
	$.post '/finish_agreement', {
		authenticity_token: AUTH_TOKEN,
		agreement_boolean: agreement_boolean,
		price: agreement_price,
		description: agreement_description
	}, ->
		window.onbeforeunload = null
		window.location = '/thank_you'

PrivatePub.subscribe "/<%= current_user.negotiation.id %>/agree", (data, channel) ->
	unless Number(data.sender_id) == user_id
		if data.tactic == 'yes_form'
			$("#receiver_page .yes_form").show()
			$('#receiver_page .no_form').hide()
			$('#receiver_content_yes').autosize()
			$('#receiver_page .agreement_boolean').val('true').attr('selected', 'selected')
			size_stop()
		else if data.tactic == 'no_form'
			$('#receiver_page .no_form').show()
			$("#receiver_page .yes_form").hide()
			$('#receiver_content_no').autosize()
			$('#receiver_page .agreement_boolean').val('false').attr('selected', 'selected')
			size_stop()
		else if data.tactic == 'none_form'
			$('#receiver_page .no_form').hide()
			$("#receiver_page .yes_form").hide()
			$('#receiver_page .agreement_boolean').val('').attr('selected', 'selected')
			size_stop()
		else if data.tactic == 'agreement_price'
			$('#receiver_page #receiver_price').val(data.key)
			unless $('.yes_form').is(':visible')
				$("#receiver_page .yes_form").show()
				$('#receiver_page .no_form').hide()
				size_stop()
		else if data.tactic == 'agreement_content'
			if data.form == 'yes'
				$('.yes_form #receiver_content_yes').val(data.key)
				$('#receiver_content_yes').trigger 'autosize.resize'
				size_stop()
				unless $('.yes_form').is(':visible')
					$("#receiver_page .yes_form").show()
					$('#receiver_page .no_form').hide()
					$('#receiver_page .agreement_boolean').val('true').attr('selected', 'selected')
					size_stop()
			else
				$('.no_form #receiver_content_no').val(data.key)
				$('#receiver_content_no').trigger 'autosize.resize'
				size_stop()
				unless $('.no_form').is(':visible')
					$("#receiver_page .yes_form").hide()
					$('#receiver_page .no_form').show()
					$('#receiver_page .agreement_boolean').val('false').attr('selected', 'selected')
					size_stop()
		else if data.tactic == 'submit_check'
			if confirm 'The other participant has requested to submit the form. Do you agree to what they have said and are you ready to submit as well?'
				$.post '/agree_channel', {
					authenticity_token: AUTH_TOKEN,
					sender_id: user_id,
					tactic: 'positive_check'
				}, ->
					save_form()
				# Save form
				# Take the user to the next page
			else
				$.post '/agree_channel', {
					authenticity_token: AUTH_TOKEN,
					sender_id: user_id,
					tactic: 'negative_check'
				}
		else if data.tactic == 'positive_check'
			save_form()
			# Take the user to the next page
		else if data.tactic == 'negative_check'
			alert 'The other particpant is not yet ready to submit the form. Please wait and try again later.'
			$('.checking_submit').remove()
			$('button').removeClass 'disabled'
		else if data.tactic == 'alert_message'
			alert "The other participant says: \"#{data.message}\""