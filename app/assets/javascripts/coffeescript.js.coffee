# Coffeescript for Negotiations


$ ->
	
	# Wizard
	$('#wizard_page').hide()
	$('.next_button').click ->
		$('#wizard_page').siblings().hide()
		$('#wizard_page').show()
		$(this).hide()
	$('.back_button').click ->
		$('#wizard_page').siblings().show()
		$('#wizard_page').hide()
		$('.next_button').show()
			
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
	
	