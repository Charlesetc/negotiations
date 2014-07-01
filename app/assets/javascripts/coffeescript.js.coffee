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
	$('body').click ->
		position_footer()
	$(window).scroll ->
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
	$('#tab-container').easytabs()
	
	