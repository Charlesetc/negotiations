# Coffeescript for Negotiations


$ ->
	
	# Variables
	ajax_count = 0
	keypress_count = 1
	# Functions
	
	
	fetch_messages_recursively = ->
		#setTimeout(fetch_messages, 5000)
		'hello'
			
	fetch_messages = ->
		$.get 'negotiations/messages', (data) ->
			$('.message_index .container').empty()
			$('.message_index .container').append(data)
			fetch_messages_recursively()
			
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
			
	position_input = ->
		difference = $(window).height() - $('#tab_negotiation').height()
		difference -= 200
		$('.message_content').css 'margin-top', difference

		width_inside_tab()
		
	width_inside_tab = ->
		w = $('#tab_negotiation').width() - 14
		$('.message_content').width(w)
		w += 4
		$('.message_index').width(w)
	
	resize_function = ->
		position_footer()
		width_inside_tab()
		
	index_height = -> 
		$('.message_index').height($(window).height() - 320)
		
	scroll_index = ->
		# h = $('.message_index .container').height()
		$('.message_index').scrollTop(900000000)
	
	# Footer Positioning
	position_footer()
	#$('body').click ->
		#position_footer()
	$(window).scroll ->
		$(window).scrollLeft(0) # Bug fix
		position_footer()
	$(window).resize ->
	    clearTimeout(resizeTimer)
	    resizeTimer = setTimeout(resize_function, 100)
		
	
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
		

			
	# The Dropdown Menu
	$('.dropdown').css 'opacity', '0'
	$('.dropdown').slideUp()
	$('.dropdown_trigger').hover ->
		$('.dropdown').css 'opacity', '1'
		$('.dropdown').slideDown('fast')
		$('.dropdown').clearQueue() # Got it working!
	$('nav').mouseleave ->
		$('.dropdown').slideUp('fast')
	
	$('.flash').animate {
		left: 0
	}, 500
	
	# Easy Tabs
	$('#tab-container').easytabs({animate: false})
	$('.tab_link').click ->
		$('.flash').slideUp('fast')
	$('#tab-container').bind 'easytabs:after', ->
		position_footer()
		resize_function()
	$('#tab-container').bind 'easytabs:before', ->
		$('footer').addClass 'fixed_footer'
		
	# Getting Content for Tabs -- runs on page load
	$('.tab').each ->
		id = $('.etabs').attr 'id'
		id = id.replace 'tabs_for_', ''
		url = $(this).attr 'id'
		access_id = url
		url = url.replace 'tab_', ''
		url = '/' + url + '/' + id
		$.get url, (data) ->
			$("##{access_id}").append(data)

	
	# User Table - Admin		
	$( document ).ajaxSuccess ->
		index_height()
		scroll_index()
		position_footer()
		position_input()
	
		fetch_messages_recursively()
		
		$('.user_table tr').click ->
			if $(this).hasClass 'user_entry'
				$(this).addClass 'selected_row'
				$(this).siblings().removeClass 'selected_row'
				admin = $(this).data('admin')
				
				if $.trim(admin) == 'true'
					$('.admin_button').html('Remove Admin')
				else 
					$('.admin_button').html('Make Admin')
					
						
		$('.negotiation_table tr').click ->
			if $(this).hasClass 'negotiation_entry'
				$(this).addClass 'selected_row'
				$(this).siblings().removeClass 'selected_row'
		

		$('.tab_link').click ->
			if $(this).children('a').text() == 'Negotiation'
				$('footer').removeClass 'fixed_footer'
				scroll_index()
		
		
		$('.message_content').keypress (e) -> 
			if e.which == 13
				content = $('.message_content').val()
				$('.message_content').val('') # Second is valid
				$('.message_content').height(20)
				$.get "/messages/create?content=#{content}"
				return false
				
		
		
		ajax_count += 1
		
		if ajax_count %% 2 == 0 # It was doing everything twice
		
						
			
			
						
			$('.admin_button').click ->
				unless $('.user_entry.selected_row').size() > 0
					alert 'You need to select a user first.'
				else
					id = $('.user_entry.selected_row').data('user-id')
					path = "users/#{id}/toggle_admin/"
					$.get path, (d) ->
						reload_admin()
						
			$('.delete_button').click ->
				unless $('.user_entry.selected_row').size() > 0
					alert 'You need to select a user first.'
				else if confirm 'Are you certain?'
					id = $('.user_entry.selected_row').data('user-id')
					path = "/destroy/#{id}/"
					$.get path, (d) ->
						reload_admin()
						
							
			$('.delete_neg_button').click ->
				unless $('.negotiation_entry.selected_row').size() > 0
					alert 'You need to select a negotiation first.'
				else if confirm 'Are you certain?'
					id = $('.negotiation_entry.selected_row').data("id")
					path = "/negotiations/destroy/#{id}/"
					$.get path, (d) ->
						reload_admin()
						
			$('.scenario_table tr').click ->
				if $(this).hasClass 'scenario_entry'
					$(this).addClass 'selected_row'
					$(this).siblings().removeClass 'selected_row'
					
			$('.delete_scenario_button').click ->
				unless $('.scenario_entry.selected_row').size() > 0
					alert 'You need to select a scenario first.'
				else if confirm 'Are you certain? This will also delete all dependent negotiations.'
					id = $('.scenario_entry.selected_row').data("id")
					path = "/scenarios/destroy/#{id}/"
					
					$.get path, (d) ->
						reload_admin()
						
			$('.edit_scenario_button').click ->
				unless $('.scenario_entry.selected_row').size() > 0
					alert 'You need to select a scenario first.'
				else
					id = $('.scenario_entry.selected_row').data("id")
					path = "/scenarios/#{id}/edit"
					window.location = path
					
					
			
			# Not part of a table, but relies on ajax
			
			# position_input()
	

			