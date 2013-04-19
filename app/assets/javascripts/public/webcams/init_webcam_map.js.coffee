@init_webcam_map = () ->
  ymaps.ready ->
    $map = $('.webcams .webcam_map')

    map = new ymaps.Map $map[0],
      center: [$map.attr('data-latitude'), $map.attr('data-longitude')]
      zoom: 12
      behaviors: []

    $('.webcams .webcams_list p').each (index, item) ->
      link = $(item).prev('a')
      title = "#{link.text().compact().normalize()}. #{$(item).text().compact().normalize()}"
      id = URLify(link.text().compact().normalize())

      point = new ymaps.GeoObject
        geometry:
          type: 'Point'
          coordinates: [$(item).attr('data-latitude'), $(item).attr('data-longitude')]
        properties:
          id: id
          hintContent: title

      point.events.add 'click', (event) ->
        link.click()

      map.geoObjects.add point

      true

    true

  true
