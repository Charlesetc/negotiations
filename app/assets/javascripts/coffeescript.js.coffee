# Coffeescript for Negotiations


$ ->
	
	# Functions
	
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
	
	
	
	# Footer Positioning
	position_footer()
	#$('body').click ->
		#position_footer()
	$(window).scroll ->
		$(window).scrollLeft(0) # Bug fix
		position_footer()
	$(window).resize ->
	    clearTimeout(resizeTimer)
	    resizeTimer = setTimeout(position_footer, 100)
		
	
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
	$('nav').mouseleave ->
		$('.dropdown').slideUp('fast')
		
	$('.flash').css 'left', '-1000px'
	
	$('.flash').animate {
		left: 0
	}, 500
	
	
	# Easy Tabs
	$('#tab-container').easytabs({animationSpeed: 200})
	$('.tab_link').click ->
		$('.flash').slideUp('fast')
	$('#tab-container').bind 'easytabs:after', ->
		position_footer()
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
	$( document ).ajaxComplete ->
		
		position_footer()
		
		$('.user_table tr').click ->
			if $(this).hasClass 'user_entry'
				$(this).addClass 'selected_row'
				$(this).siblings().removeClass 'selected_row'
				admin = $(this).data('admin')
				
				if $.trim(admin) == 'true'
					$('.admin_button').html('Remove Admin')
				else 
					$('.admin_button').html('Make Admin')
				
					
		$('.admin_button').click ->
			unless $('.selected_row').length > 0
				alert 'You need to select a user first.'
			id = $('.selected_row').data('user-id')
			path = "users/#{id}/toggle_admin/"
			$.get path, (d) ->
				id = $('.etabs').attr 'id'
				id = id.replace 'tabs_for_', ''
				$.get "/admin/#{id}", (data) ->
					$('#tab_admin').empty()
					$('#tab_admin').append(data)
					
		$('.delete_button').click ->
			unless $('.selected_row').length > 0
				alert 'You need to select a user first.'
			else 
				#certian = confirm 'Are you certain?'
				#if certian 
				id = $('.selected_row').data('user-id')
				path = "/destroy/#{id}/"
				$.get path, (d) ->
					id = $('.etabs').attr 'id'
					id = id.replace 'tabs_for_', ''
					$.get "/admin/#{id}", (data) ->
						$('#tab_admin').empty()
						$('#tab_admin').append(data)