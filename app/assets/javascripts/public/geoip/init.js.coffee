@init_geoip = ->

  $('.js-geoip').dialog
    autoOpen: true
    draggable: false
    modal: true
    position: ['center', 'center']
    resizable: false
    title: 'Выбор местоположения'
    width: 450
    height: 130
    open: (evt, ui) ->
      $('body').css('overflow', 'hidden')
    close: (event, ui) ->
      $('body').css('overflow', 'auto')

    true

  $('.js-geoip-close-dialog').click ->
    $('.js-geoip').dialog "close"

    false
