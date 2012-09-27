@init_loading_items = () ->
  $('body > nav.pagination').css
    'height': '0'
    'visibility': 'hidden'
  list_url = window.location.pathname
  list = $('.content_wrapper .affiches_list ul:first, .content_wrapper .organizations_list ul:first')
  first_item = $('li:first', list)
  last_item = first_item.siblings().last()
  last_item_top = last_item.position().top
  page = 1
  busy = false
  $(window).scroll ->
    if $(this).scrollTop() + $(this).height() >= last_item_top && !busy
      busy = true
      $.ajax
        url: "#{list_url}?page=#{parseInt(page) + 1}"
        beforeSend: (jqXHR, settings) ->
          $('<li class="ajax_loading_items_indicator">&nbsp;</li>').appendTo(list)
          true
        complete: (jqXHR, textStatus) ->
          $('li.ajax_loading_items_indicator', list).remove()
          true
        success: (data, textStatus, jqXHR) ->
          list.append(data)
          last_item = first_item.siblings().last()
          last_item_top = last_item.position().top
          page += 1
          busy = false if data.length
          true
        error: (jqXHR, textStatus, errorThrown) ->
          console.log jqXHR.responseText if console && console.log
          true
    true
  true
