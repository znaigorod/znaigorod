@init_3dtourme_stat = () ->
  link = $('a.3dtourme')
  link.click (event) ->
    yaCounter14923525.reachGoal('3dtourme') if yaCounter14923525?
    true
  true

@init_tickets_stat = () ->
  link_on_list = $('.tickets_list li a.payment_link')
  link_on_list.click (event) ->
    yaCounter14923525.reachGoal('ticket_on_list') if yaCounter14923525?
    true
  link_on_affiche = $('.affiche .tickets a.payment_link')
  link_on_affiche.click (event) ->
    yaCounter14923525.reachGoal('ticket_on_affiche') if yaCounter14923525?
    true
  true

@init_training_banner_stat = () ->
  $('div.training').mousedown ->
    yaCounter14923525.reachGoal('gadecky_training') if yaCounter14923525?
    true

  return

@init_questions_banner_stat = () ->
  $('.top_headline a').click ->
    yaCounter14923525.reachGoal('questions_banner') if yaCounter14923525?
    true

  return
