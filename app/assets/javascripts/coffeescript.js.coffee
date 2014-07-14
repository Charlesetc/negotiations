# Coffeescript for Negotiations


$ ->
	
	# Variables
	ajax_count = 0
	keypress_count = 1
	# Functions
	
	
	# fetch_messages_recursively = ->
	# 	#fetch_messages() # Turned off longpolling
	#
	# into_message_index = (data) ->
	# 	alert 'data'
	# 	$('.message_index .container').empty()
	# 	$('.message_index .container').append(data)
	#
	# fetch_messages = ->
	# 	setTimeout message_ajax, 3000
	#
	# message_ajax = ->
	# 	$.ajax {
	# 		url:'negotiations/messages',
	# 		complete: fetch_messages_recursively(),
	# 		timeout: 30000,
	# 		success: into_message_index(data), # Not being called
	# 	}
			
	next_page = -> 
		$('#wizard_page').siblings().hide()
		$('#wizard_page').show()
		$('.next_button').hide()
		
	back_page = ->
		$('#wizard_page').siblings().show()
		$('#wizard_page').hide()
		$('.next_button').show()
		
	position_footer = -> 
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
			
	# clear_input = ->
	# 	#$('.message_content').val('').change()
			
	clear_selected = ->
		$('.selected_row').removeClass 'selected_row'
	
	resize_function = ->
		scroll_index()
		index_height()
		position_footer()
		
	

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
		$('#show_body').append "<div id = 'clock'>20:00</div>"
		
	tick_clock = ->
		numbers = $('#clock').text().split ':'
		seconds = Number(numbers[1])
		seconds -= 1
		if seconds < 0
			seconds = 59
			numbers[0] = tock_clock()
		else if seconds < 10
			seconds = "0#{seconds}"
		$('#clock').empty().append numbers[0] + ":" + seconds
		
	tock_clock = ->
		numbers = $('#clock').text().split ':'
		minutes = numbers[0]
		if minutes == 0
			alert "Time's up!"
			minutes
		else
			minutes -= 1
	
		
	add_spin = ->
		target = document.getElementById('waiting_page');
		spin = new Spinner({
			top: '72%',
			width: 20,
			length:0,
			lines: 7,
			trail: 50,
			speed: 0.5,
			radius: 30,
			rotate: 14,
			color: '#333'
		}).spin(target)
		
		
		
	scroll_index()
	
	position_footer()
	
	add_clock()
	
	add_spin()
	
	setInterval tick_clock, 1000
	
	$(window).scroll ->
		$(window).scrollLeft(0) # Bug fix
		position_footer()
	$(window).resize ->
	    clearTimeout(resizeTimer)
	    resizeTimer = setTimeout(resize_function, 20)
		
	
	# Comma Language
	$('.language_array input').keypress (e) ->
		if e.keyCode == 32
			if $(this).val().match /\w$/
				$(this).val($(this).val() + ',')	


	
	# Wizard
	$('#wizard_page').hide()
	$('.next_button').click ->
		next_page()
	$('.back_button').click ->
		back_page()
	$('#wizard_page').parent().children('div').children('input').keypress (e) ->      
		if e.which == 13 and $(this).parent().attr('id') == 'last_input'
			next_page()
			return false
		else if e.which == 13 
			$(this).parent().next().next().children('input').focus()
			return false
			
		
	# Ajax for Last Seen
	
	last_seen_ajax = -> 
		user_id = $('body').data('id')
		if user_id
			$.post "/users/#{user_id}/last_seen", {
				authenticity_token: AUTH_TOKEN
			}
		
	last_seen_ajax()
	setInterval(last_seen_ajax, 30000)
		
		
	
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
	}, 500                ## 
	
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
		
		$('.message_content').click -> 
			$('footer').removeClass 'fixed_footer'
			$('footer').css 'position', 'relative'
			$('footer').css 'top', '-9px'
			$('footer').css 'left', '16px'
		
		$('.message_content').keypress (e) -> 
			position_footer()
			if e.which == 13
				content = $('.message_content').val()
				$('.message_content').val('').change()
				$.get "/messages/create?content=#{content}"
				# setTimeout clear_input, 1
				return false

						
		$('.message_content').expanding()
		
					
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
	

		