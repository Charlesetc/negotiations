# Coffeescript for Negotiations


$ ->
	
	# Variables
	ajax_count = 0
	keypress_count = 1
	clock_count = 0
	# CURRENT_USER_ID = $('body').data('id')
	
 	# Functions

	next_dot = ->
		dot = $('.current_dot')
		dot.removeClass 'current_dot'
		dot.next().addClass 'current_dot'
		
	back_dot = ->
		dot = $('.current_dot')
		dot.removeClass 'current_dot'
		dot.prev().addClass 'current_dot'
	
	next_page = -> 
		$('#wizard_page').siblings().hide()
		$('#wizard_page').show()
		$('.next_button').hide()
		$('body').addClass '2nd_wizard_page'
		next_dot()
		
	back_page = ->
		$('#wizard_page').siblings().show()
		$('#wizard_page').hide()
		$('.next_button').show()
		$('body').removeClass '2nd_wizard_page'
		back_dot()
		
	next_page_2 = ->
		$('#wizard_page_2').siblings().hide()
		$('#wizard_page_2').show()
		$('body').removeClass '2nd_wizard_page'
		$('body').addClass '3rd_wizard_page'
		next_dot()
		
		
	back_page_2 = ->
		$('#wizard_page_2').siblings().show()
		$('#wizard_page_2').hide()
		$('body').addClass '2nd_wizard_page'
		$('body').removeClass '3rd_wizard_page'
		back_dot()
		
	next_page_3 = ->
		$('#wizard_page_3').siblings().hide()
		$('#wizard_page_3').show()
		$('body').removeClass '3rd_wizard_page'
		$('body').addClass '4th_wizard_page'
		next_dot()
		
	back_page_3 = ->
		$('#wizard_page_3').siblings().show()
		$('#wizard_page_3').hide()
		$('body').removeClass '4th_wizard_page'
		$('body').addClass '3rd_wizard_page'
		back_dot()
		
	next_page_4 = ->
		$('#wizard_page_4').siblings().hide()
		$('#wizard_page_4').show()
		$('body').removeClass '4th_wizard_page'
		$('body').addClass '5th_wizard_page'
		next_dot()
		
	back_page_4 = ->
		$('#wizard_page_4').siblings().show()
		$('#wizard_page_4').hide()
		$('body').removeClass '5th_wizard_page'
		$('body').addClass '4th_wizard_page'
		back_dot()
	
	position_footer = ->  # Copied in Messages.js.coffee!
		if $(document).height() > $(window).height()
			$('footer').removeClass 'fixed_footer'
		else 
			$('footer').addClass 'fixed_footer'
	
	reload_admin = ->
		id = $('.etabs').attr 'id'
		id = id.replace 'tabs_for_', ''
		$.get "/admin/#{id}", (data) ->
			$('#tab_admin').empty()
			$('#tab_admin').append(data)
			
	play_sound = ->
		$('body').append "<embed src=\"/sound.wav\" hidden=\"true\" autostart=\"true\" loop=\"false\" />"

			
	reload_negotiation = -> 
		id = $('.etabs').attr 'id'
		id = id.replace 'tabs_for_', ''
		$.get "/negotiations/messages", (data) ->
			$('.message_index .container').empty()
			$('.message_index .container').append(data)
			
	position_after = ->
		height = $(document).height()
		$("head").append("<style type='text/css' id='styling'>
		body::after { height: #{height}px }
			</style>")
			
	check_empty = -> 
		empty = false
		$('#wizard_page').siblings('div').children('input:password, input:text').each (index) ->
			if $(this).val() == ''
				empty = true
		return empty
	
	check_empty_2 = ->
		empty = false
		$('#wizard_page_2').siblings('div').children('input:password, input:text').each (index) ->
			if $(this).val() == ''
				empty = true
		return empty
		
	check_empty_3 = ->
		empty = false
		$('#wizard_page_3').siblings('div').children('input:password, input:text').each (index) ->
			if $(this).val() == ''
				empty = true # Should work
		return empty
		
	check_empty_4 = ->
		empty = false
		$('#wizard_page_4').siblings('div').children('input:password, input:text').each (index) ->
			if $(this).val() == ''
				empty = true # Should work
		return empty
			
	next_enabled = ->
		if check_empty()
			$('.next_button').addClass 'disabled'
		else
			$('.next_button').removeClass 'disabled'
	
	next_enabled_2 = ->
		if check_empty_2()
			$('.next_button_2').addClass 'disabled'
		else
			$('.next_button_2').removeClass 'disabled'
	
	next_enabled_3 = ->
		if check_empty_3()
			$('.next_button_3').addClass 'disabled'
		else
			$('.next_button_3').removeClass 'disabled'
	
	next_enabled_4 = ->
		if check_empty_4()
			$('.next_button_4').addClass 'disabled'
		else
			$('.next_button_4').removeClass 'disabled'		
	
	clear_selected = ->
		$('.selected_row').removeClass 'selected_row'
	
	resize_function = ->
		scroll_index()
		index_height()
		position_footer()
		size_stop()

	index_height = ->
		$('.message_index').height($(window).height() - 355)
		$('#background_block').height($(window).height() - 246)
		
	consent_height = -> 
		$('#scroll_consent').css 'height', ($(window).height() - 300)
		$('body').css 'overflow', 'hidden' if $('#scroll_consent').length > 0
		
	scroll_index = ->
		height = $('.container div').length * 10000
		$('.message_index').scrollTop(height)
		
	add_clock = ->
		time_left = $('#negotiation_block').data('time-left')
		time_color = $('#negotiation_block').data('time-color')
		minutes = Math.floor(Number(time_left) / 60)
		seconds = time_left - (60 * minutes)
		if seconds < 10
			seconds = "0#{seconds}"
		$('#show_body').append "<div id = 'clock' class = 'going_clock'>#{minutes}:#{seconds}</div>"
		if time_color == '#3388FF'
			minutes += 10
			$('#clock').empty().append "#{minutes}:#{seconds}"
			

	tick_clock = ->
	<% if current_user %>
	<% unless current_user.admin %>
		$("#clock").hide()
		# time_color = $('#negotiation_block').data('time-color')
# 		$("#clock").css 'color', time_color
# 		end_time = <%= current_user.negotiation.first_end_time %>
# 		now = new Date()
# 		later = new Date(end_time)
# 		time = later - now
#
# 		minutes = Math.floor(time / 60000)
# 		seconds = Math.floor((time / 1000) % 60)
#
# 		if minutes < 0
# 			minutes += 10
# 			seconds = 60 - (seconds * -1)
#
# 		if (minutes == 0 and seconds == 0) or (minutes < 0)
# 						#
# 			# $('#clock').empty().append "10:00"
# 			#
#
#
# 			if clock_count == 0
# 				if time_color == 'white'
# 					$('#negotiation_block').data('time-color', '#3388ff')
# 					alert '20 minutes have passed. You now
# 					either have the option of continuing on
# 					by pressing "Fill out Form" or negotiating
# 					for another 10 minutes. Good luck!'
# 					return
# 				else
# 					$.post 'users/accept_alert_request', {
# 						authenticity_token: AUTH_TOKEN,
# 						tactic: 'accept'
# 					}
# 					return					#
# 				# else
# 				# 	clock_count = 1
# 			else
# 				$('#clock').toggleClass('invisible_clock')
# 		else
#
# 			seconds = "#{seconds}"
# 			minutes = "#{minutes}"
# 			if seconds.length == 1
# 				seconds = "0#{seconds}"
# 			if minutes.length == 1
# 				minutes = "0#{minutes}"
#
# 			$('#clock').empty().append (minutes + ":" + seconds)
	<% end %>
	<% end %>
		
	add_spin = ->
		target = document.getElementById('waiting_page')
		spin = new Spinner({
			top: '75%',
			width: 20,
			length:0,
			lines: 7,
			trail: 50,
			speed: 0.5,
			radius: 30,
			rotate: 14,
			color: '#333'
		}).spin(target)
		
	
	set_waiting = ->
		if $('#waiting_page').length > 0
			window.onbeforeunload = "If you leave this page you
			will not be notified when the other participant is ready."
		
	alert_agreement = ->
		"Leaving this page could invalidate the study."
	set_agreement = ->
		if $('#agreement_page').length > 0
			window.onbeforeunload = alert_agreement
			
	replace_newlines = ->
		$('textarea').each ->
			$(this).html($(this).html().replace(/_NEWLINE_/g, ''))		
		$('#background_page').children().each ->
			$(this).html($(this).html().replace(/_NEWLINE_/g, '<br/>')) # More specific
		$('#background_block').children().each ->                       # to not inter-
			$(this).html($(this).html().replace(/_NEWLINE_/g, '<br/>')) # fere with me-
																		# ssages
			
	remove_tab = ->
		$('#tab_link_supervisor').hide()
		
	remove_tab() # Comment out this line to bring back supervisor chat.
		
	replace_newlines()
		
	scroll_index()
	
	position_footer()
	
	add_clock()
	
	add_spin()
	
	if window.location.pathname == '/'
		tick_clock()
		
		setInterval tick_clock, 1000
	
	set_waiting()
	set_agreement()
	
	$(window).scroll ->
		$(window).scrollLeft(0) # Bug fix
		position_footer()
	$(window).resize ->
	    clearTimeout(resizeTimer)
	    resizeTimer = setTimeout(resize_function, 20)
		
	
	# Comma Language -- doesn't work in Firefox?
	$('.language_array input').keypress (e) ->
		if e.keyCode == 32
			if $(this).val().match /\w$/
				$(this).val($(this).val() + ',')	
	
	
	## Agreement Form
		 		   # Copied at agree.coffee
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
	
	
	# Select Changing
	
	$('.yes_form').hide()
	$('.no_form').hide()
			
	$('.typing').slideUp()
	
	
	$('#sender_page .agreement_boolean').change ->
		if $(this).val() == 'true'
			$("#sender_page .yes_form").show()
			$('#sender_page .no_form').hide()
			$('#agreement_content_yes').autosize()
			size_stop()
			$.post '/agree_channel', {
				authenticity_token: AUTH_TOKEN,
				sender_id: CURRENT_USER_ID,
				tactic: 'yes_form'
			}
		
		else if $(this).val() == 'false'
			$('#sender_page .no_form').show()
			$("#sender_page .yes_form").hide()
			$('#agreement_content_no').autosize()
			size_stop()
			$.post '/agree_channel', {
				authenticity_token: AUTH_TOKEN,
				sender_id: CURRENT_USER_ID,
				tactic: 'no_form'
			}
		
		else
			$('#sender_page .no_form').hide()
			$("#sender_page .yes_form").hide()
			size_stop()
			$.post '/agree_channel', {
				authenticity_token: AUTH_TOKEN,
				sender_id: CURRENT_USER_ID,
				tactic: 'none_form'
			}
			
	$('#agreement_price').keypress (e) ->
		key = $(this).val() + String.fromCharCode e.which
		$.post '/agree_channel', {
			authenticity_token: AUTH_TOKEN,
			sender_id: CURRENT_USER_ID,
			tactic: 'agreement_price',
			key: key # Actually a Value
		}
		
	$('.yes_form #agreement_content_yes').keypress (e) ->
		key = $(this).val() + String.fromCharCode e.which
		$.post '/agree_channel', {
			authenticity_token: AUTH_TOKEN,
			sender_id: CURRENT_USER_ID,
			tactic: 'agreement_content',
			form: 'yes',
			key: key # Actually a Value
		}
		
	$('.no_form #agreement_content_no').keypress (e) ->
		key = $(this).val() + String.fromCharCode e.which
		$.post '/agree_channel', {
			authenticity_token: AUTH_TOKEN,
			sender_id: CURRENT_USER_ID,
			tactic: 'agreement_content',
			form: 'no',
			key: key # Actually a Value
		}
		
	$('#agreement_page input, #agreement_page textarea').keypress ->
		size_stop()
		
		
	$('.submit_yes, .submit_no').click ->
		unless $(this).hasClass 'disabled'
			$(this).addClass 'disabled'
			$.post '/agree_channel', {
				authenticity_token: AUTH_TOKEN,
				sender_id: CURRENT_USER_ID,
				tactic: 'submit_check'
			}
			$(this).after('<br/><span class = "checking_submit"><%= t('Checkin') %></span>')
			size_stop()
		
	# $('.submit_no').click ->
	# 	$.post '/agree_channel', {
	# 		authenticity_token: AUTH_TOKEN,
	# 		sender_id: CURRENT_USER_ID,
	# 		tactic: 'submit_check'
	# 	}
	#
		
	# Dots
	$('.dot').click ->
		if $(this).nextAll('.current_dot').length > 0
			if $('body').hasClass '2nd_wizard_page'
				back_page()
			else if $('body').hasClass '3rd_wizard_page'
				back_page_2()
			else if $('body').hasClass '4th_wizard_page'
				back_page_3()
			else
				back_page_4()
		else if $(this).prevAll('.current_dot').length > 0
			if $('body').hasClass '2nd_wizard_page'
				unless check_empty_2()
					next_page_2()
			else if $('body').hasClass '3rd_wizard_page'
				unless check_empty_3()
					next_page_3()
			else if $('body').hasClass '4th_wizard_page'
				unless check_empty_4()
					next_page_4()
			else
				unless check_empty()
					next_page()
				
	next_enabled()
	$('#wizard_page').siblings().children('input').keypress (e) ->
		next_enabled()
		
	next_enabled_2()
	$('#wizard_page_2').siblings().children('input').keypress (e) ->
		next_enabled_2()
	
	next_enabled_3()
	$('#wizard_page_3').siblings().children('input').keypress (e) ->
		next_enabled_3()
		
	next_enabled_4()
	$('#wizard_page_4').siblings().children('input').keypress (e) ->
		next_enabled_4()
	
	
	# Wizard
	$('#wizard_page').hide()
	$('#wizard_page_2').hide()
	$('#wizard_page_3').hide()
	$('#wizard_page_4').hide()
	$('.next_button').click ->
		unless $(this).hasClass 'disabled'
			next_page()
	$('.back_button').click ->
		back_page()
	$('.next_button_2').click ->
		unless $(this).hasClass 'disabled'
			next_page_2()
	$('.next_button_3').click ->
		unless $(this).hasClass 'disabled'
			next_page_3()
	$('.next_button_4').click ->
		unless $(this).hasClass 'disabled'
			next_page_4()
	$('.back_button_4').click ->
		back_page_4()
	$('.back_button_3').click ->
		back_page_3()
	$('.back_button_2').click ->
		back_page_2()
	$('#wizard_page').parent().children('div').children('input').keypress (e) ->      
		if e.which == 13 and $(this).parent().hasClass 'last_input'
			unless $('.next_button').hasClass 'disabled'
				next_page()
			return false
		else if e.which == 13 
			$(this).parent().next().next().children('input').focus()
			return false
			
	$('#wizard_page_2').parent().children('div').children('input').keypress (e) ->      
		if e.which == 13 and $(this).parent().hasClass 'last_input'
			unless $('.next_button_2').hasClass 'disabled'
				next_page_2()
			return false
		else if e.which == 13 
			$(this).parent().next().next().children('input').focus()
			return false
			
	$('.other_input').keypress (e) ->
		$(this).siblings().attr 'value', $(this).val()		
	
	
		
	# Ajax for Last Seen
	
	last_seen_ajax = -> 
		user_id = $('body').data('id')
		if user_id
			$.post "/users/#{user_id}/last_seen", {
				authenticity_token: AUTH_TOKEN
			}
		
	last_seen_ajax()
	setInterval(last_seen_ajax, 60000)
		
		
		# Unneeded because it has class 'expanding'
	#
	# $('.message_content').expanding()
	
	
	# Buttons
	
	$('.consent_button').click ->
		id = $('body').data('id')
		$.post "/users/#{id}/accept_consent", {
			authenticity_token: AUTH_TOKEN
		}, (data) ->
			$('body').empty().append(data)
			window.location.pathname = '/background'
	
	$('.instructions_button').click ->
		window.location.pathname = '/consent'
		
	$('.background_button').click ->
		window.location.pathname = '/accept_background'
		
	$('.agreement_button').click ->
		unless $(this).hasClass 'disabled'
			$('#background_block').append '<p class="agreement_waiting"><%= t("ticktocklalala") %></p>'
			$(this).addClass 'disabled'
			$.post '/users/alert_request', {
				authenticity_token: AUTH_TOKEN
			}
			
	$('#alert_partner').click ->		
		# $('#alert_content').autosize()
		$('#alert_content_div').css 'display', 'block'
		$('#alert_content_div').animate {
			opacity: 1
		}, 'fast'
		
	$('#alert_content_div').click ->
		$(this).animate {
			opacity:0
		}, 'fast', ->
			$(this).css 'display', 'none'
			$('#alert_content').val('')
			
			
	$('#alert_content_div div').click (e) ->
		e.stopPropagation()	
		
	$('#send_alert').click ->
		$('#alert_content_div').click()
		message = $('#alert_content').val()
		if message
			$.post '/agree_channel', {
				authenticity_token: AUTH_TOKEN,
				sender_id: CURRENT_USER_ID,
				tactic: 'alert_message',
				message: message
			}
	
	$('#alert_content').keypress (e) ->
		if e.which == 13
			$('#send_alert').click()
		
	$(document).keyup (e) ->
		if e.keyCode == 27
			$('#alert_content_div').click()

			
	# The Dropdown Menu
	$('.dropdown').css 'opacity', '1'
	$('.dropdown').slideUp('fast')
	$('.dropdown_trigger').hover ->
		$('.dropdown').slideDown('fast')
		$('.dropdown').clearQueue()
	$('nav').mouseleave ->
		$('.dropdown').slideUp('fast')
		
		
	# Flash Animation     ##
	$('.flash').animate { ## Not dropdown.
		left: 0           ## Not dropdown.
	}, 500                ##  ?
	
	# Easy Tabs
	$('#tab-container').easytabs({animate: false})
	$('.tab_link').click ->
		$('.flash').slideUp('fast')
	$('#tab-container').bind 'easytabs:after', ->
		position_footer()
		resize_function()
	$('#tab-container').bind 'easytabs:before', ->
		$('footer').addClass 'fixed_footer'
	
	# User Table - Admin		
	$( document ).ajaxSuccess ->
		index_height()
		position_footer()
		position_after()
		consent_height()		
		# size_stop()
		
		
		$('.user_table tr').click ->
			if $(this).hasClass 'user_entry'
				
				clear_selected()
				
				$(this).addClass 'selected_row'
				
				admin = $(this).data('admin')
				
				if $.trim(admin) == 'true'
					$('.admin_button').html('Remove Admin')
				else 
					$('.admin_button').html('Make Admin')
					
				negotiation= $(this).data('negotiation-id')
				scenario = $(".negotiation_entry[data-id='#{negotiation}']").addClass('selected_row').data('scenario-id')
				$(".scenario_entry[data-id='#{scenario}']").addClass 'selected_row'
					
						
		$('.negotiation_table tr').click ->
			if $(this).hasClass 'negotiation_entry'
				
				clear_selected()
				
				$(this).addClass 'selected_row'
				
				users = $(this).data('user-id')
				for user in users
					$(".user_entry[data-user-id='#{user}']").addClass 'selected_row'
					
				scenario = $(this).data('scenario-id')
				$(".scenario_entry[data-id='#{scenario}']").addClass 'selected_row'
			
		$('.negotiation_table tr').dblclick ->	
			id = $('.negotiation_entry.selected_row').data('id')
			window.location = "/inspect/#{id}"
						
		$('.scenario_table tr').click ->
			if $(this).hasClass 'scenario_entry'
				
				clear_selected()
				
				$(this).addClass 'selected_row'
				
				scenario = $(this).data('id')
				users = []
				$(".negotiation_entry[data-scenario-id='#{scenario}']").addClass('selected_row').each ->
					users.push $(this).data('user-id')...
				for user in users
					$(".user_entry[data-user-id='#{user}']").addClass 'selected_row'

		$('.tab_link').click ->
			if $(this).children('a').text() == 'Negotiation'
				if $('.message_index').length() == 1
					$('footer').removeClass 'fixed_footer'
					scroll_index()
		
		if $('.message_content').length == 1
			$('footer').removeClass 'fixed_footer'
			$('footer').css 'position', 'relative'
			$('footer').css 'top', '-9px'
			$('footer').css 'left', '16px'
		


					
		$('.admin_button').click ->
			if $('.user_entry.selected_row').size() == 0
				alert 'Please select a user first.'
			else if $('.user_entry.selected_row').size() > 1
				alert 'Please select only one user first.'
			else
				id = $('.user_entry.selected_row').data('user-id')
				path = "users/#{id}/toggle_admin/"
				$.get path, (d) ->
					reload_admin()
					
		$('.delete_button').click ->
			if $('.user_entry.selected_row').size() == 0
				alert 'You need to select a user first.'
			else if $('.user_entry.selected_row').size() > 1
				alert 'Please select only one user first.'
			else if confirm 'Are you certain?'
				id = $('.user_entry.selected_row').data('user-id')
				path = "/destroy/#{id}/"
				$.get path, (d) ->
					reload_admin()
					
						
		$('.delete_neg_button').click ->
			if $('.negotiation_entry.selected_row').size() == 0
				alert 'Please select a negotiation first.'
			else if $('.negotiation_entry.selected_row').size() > 1
				alert 'Please select only one negotiation first.'
			else if confirm 'Are you certain?'
				id = $('.negotiation_entry.selected_row').data("id")
				path = "/negotiations/destroy/#{id}/"
				$.get path, (d) ->
					reload_admin()
					
		$('.inspect_neg_button').click ->
			if $('.negotiation_entry.selected_row').size() == 0
				alert 'Please select a negotiation first.'
			else if $('.negotiation_entry.selected_row').size() > 1
				alert 'Please select only one negotiation first.'
			else
				id = $('.negotiation_entry.selected_row').data('id')
				window.location = "/inspect/#{id}"
		
				
		$('.delete_scenario_button').click ->
			if $('.scenario_entry.selected_row').size() == 0
				alert 'Please select a scenario first.'
			else if $('.scenario_entry.selected_row').size() > 1
				alert 'Please select only one scenario first.'
			else if confirm 'Are you certain? This will also delete all dependent negotiations.'
				id = $('.scenario_entry.selected_row').data("id")
				path = "/scenarios/destroy/#{id}/"
				
				$.get path, (d) ->
					reload_admin()
					
		$('.edit_scenario_button').click ->
			if $('.scenario_entry.selected_row').size() == 0
				alert 'Please select a scenario first.'
			else if $('.scenario_entry.selected_row').size() > 1
				alert 'Please select only one scenario first.'
			else
				id = $('.scenario_entry.selected_row').data("id")
				path = "/scenarios/#{id}/edit"
				window.location = path
				

		
		# Not part of a table, but relies on ajax
		
		# position_input()
	

		