init_addresses_pagination = (map) ->
  busy = false
  list = $('.result_list')
  pagination = $('.pagination')
  next_link = $('.next a', pagination)

  list.jScrollPane
    autoReinitialise: true
    verticalGutter: 0
    showArrows: true
    mouseWheelSpeed: 30

  block_offset = $('li:last', list).outerHeight(true, true) * ($('li', list).length - 3) - $('.jspContainer', list).outerHeight(true, true)
  if next_link.length
    list.bind 'jsp-scroll-y', (event, scrollPositionY, isAtTop, isAtBottom) ->
      if block_offset < scrollPositionY && !busy
        busy = true
        $.ajax
          url: next_link.attr('href')
          success: (response, textStatus, jqXHR) ->
            return true if (typeof next_link.attr('href')) == 'undefined'
            list = $("#{response}").find('.result_list').children()
            $('.jspPane', event.target).append(list)
            block_offset = $('li:last', event.target).outerHeight(true, true) * ($('li', event.target).length - 30) - $('.jspContainer', list).outerHeight(true, true)
            busy = false
            pagination.html($('.pagination', response).html())
            next_link = $('.next a', pagination)
            $("#{response}").find('.result_list .show_map_link_side_map').each (index, item) ->
              add_point_on_side_map(item, map)
              true
            true
        true
    true

add_point_on_side_map = (item, map) ->

  init_gallery = () ->
    $('.balloon_photos a').colorbox
      close: 'закрыть'
      current: '{current} из {total}'
      maxHeight: '90%'
      maxWidth: '90%'
      next: 'следующая'
      opacity: '0.5'
      photo: true
      previous: 'предыдущая'
      returnFocus: false

    true

  set_photos_to_balloon = (point) ->
    content = point.properties.get('balloonContent')
    coordinates = point.geometry.getCoordinates()
    text = content.compact()

    wrapped_content = $("<div>#{content}</div>")

    unless $('.balloon_photos', wrapped_content).length
      $.ajax
        url: "/yamp_geocoder_photo?coords=#{coordinates[1]},#{coordinates[0]}"
        beforeSend: () ->
          content = "" +
          "<div class='balloon_photos'>" +
          "<center>" +
          "<img class='loading_photo' src='/assets/public/colorbox_loading.gif' />" +
          "<br />#{text}" +
          "</center>" +
          "</div>"
          point.properties.singleSet('balloonContent', content)
        success: (response, textStatus, jqXHR) ->
          if response.length
            content = "" +
              "<div class='balloon_photos'>" +
              "<center>" +
              "<a href='#{response[0].L.href}' class='balloon' title='#{text}' " +
              "rel='photos_#{coordinates[1].replace('.', '')}#{coordinates[0].replace('.', '')}'>" +
              "<img src='#{response[0].S.href}' width='#{response[0].S.width}' height='#{response[0].S.height}'" +
              " style='padding-top: 5px' />" +
              "<div class='zoom'></div>" +
              "</a><br />#{text}" +
              "</center>"
            response.each (elem) ->
              content += "" +
                "<a href='#{elem.L.href}' class='balloon' title='#{text}' " +
                "rel='photos_#{coordinates[1].replace('.', '')}#{coordinates[0].replace('.', '')}'" +
                "style='display:none' >" +
                "<img src='#{elem.S.href}' width='0' height='0' />" +
                "</a>"
                true
            , 1
            content += "</div>"
            point.properties.singleSet('balloonContent', content)
            init_gallery()
          else
            content = ""+
            "<div class='balloon_photos'>" +
            "<center>" +
            "<div class='not_found'>" +
            "<p>Нет фотографии</p>" +
            "</div>" +
            "<br />#{text}" +
            "</center>" +
            "</div>"
            point.properties.singleSet('balloonContent', content)

          true

    true

  add_events_to_list = (point) ->

    data_hint = point.properties.get('hintContent')
    elem = $(".yandex_addresses_side_map [data-hint='#{data_hint}']").parent().parent()

    elem.mouseenter () ->
      if !elem.hasClass("clicked")
        elem.css({'background': '#f5f3f3'})
        point.options.set('iconImageHref', '/assets/public/side_map_icon_h.png')
        if (map.getZoom() < 17)
          map.geoObjects.remove(point)
          map.geoObjects.add(point)

    elem.mouseleave () ->
      if !elem.hasClass("clicked")
        elem.css({'background': '#fff'})
        point.options.set('iconImageHref', '/assets/public/side_map_icon.png')

    elem.click () ->
      if elem.hasClass("clicked")
        elem.removeClass("clicked")
        elem.css({'background': '#fff'})
        point.balloon.close()
      else
        map.setCenter(point.geometry.getCoordinates())
        map.setZoom(17) if map.getZoom() != 17
        elem.css({'background': '#e3e3e3'})
        $('.result_list .clicked').removeClass("clicked")
        elem.addClass("clicked")
        set_photos_to_balloon(point)
        point.balloon.open()
      false

  add_events_on_map = (point) ->

    data_hint = point.properties.get('hintContent')
    elem = $(".yandex_addresses_side_map [data-hint='#{data_hint}']").parent().parent()

    point.events.add 'mouseenter', (event) ->
      point.options.set('iconImageHref', '/assets/public/side_map_icon_h.png')
      elem.css({'background': '#f5f3f3'})

    point.events.add 'mouseleave', (event) ->
      point.options.set('iconImageHref', '/assets/public/side_map_icon.png')
      elem.css({'background': '#fff'})

    point.balloon.events.add 'open', (event) ->
      init_gallery()

    point.balloon.events.add 'close', (event) ->
      point.options.set('iconImageHref', '/assets/public/side_map_icon.png')
      elem.css({'background': '#fff'})
      elem.removeClass("clicked")

    point.events.add 'click', (event) ->
      elem.css({'background': '#e3e3e3'})
      $('.result_list .clicked').removeClass("clicked")
      elem.addClass("clicked")
      set_photos_to_balloon(event.get('target'))

  point = new ymaps.GeoObject
    geometry:
      type: 'Point'
      coordinates: [$(item).attr('data-latitude'), $(item).attr('data-longitude')]
    properties:
      hintContent: $(item).attr('data-hint')
      balloonContent: "#{$(item).attr('data-hint')} "
      openBalloonOnClick: true
    ,
      iconImageHref: '/assets/public/side_map_icon.png'
      iconImageOffset: [-15, -40]
      iconImageSize: [37, 42]


  add_events_on_map(point)

  add_events_to_list(point)

  map.geoObjects.add point if (typeof map != 'undefined')

  true

@init_addresses_side_map = () ->

  ymaps.ready ->
    $map = $('.results_with_map .yandex_side_map')

    addresses = $('.results_with_map .result_list .show_map_link_side_map')

    long = addresses.first().data('longitude')
    lat = addresses.first().data('latitude')

    map = new ymaps.Map $map[0],
      center: [lat, long]
      zoom: 17
      behaviors: ['drag', 'scrollZoom']
    ,
      maxZoom: 23
      minZoom: 12

    map.controls.add 'zoomControl',
      top: 5
      left: 5

    addresses.each (index, item) ->

      add_point_on_side_map(item, map)

      true

    init_addresses_pagination(map)

    if addresses.length == 1
      addresses.click()

    true

  true
