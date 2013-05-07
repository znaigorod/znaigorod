@init_pay_ticket = () ->
  link = $('a.pay_ticket')
  link.click ->
    $.ajax
      type: 'GET'
      url: link.attr('href')
      success: (data, textStatus, jqXHR) ->
        container = $('<div class="ticket_payment_form_wrapper" />').appendTo('body').hide().html(data)
        container.dialog
          width: 640
          height: 480
          title: 'Форма заказа билета'
          modal: true
          resizable: false
        true
      error: (jqXHR, textStatus, errorThrown) ->
        wrapped = $("<div>" + jqXHR.responseText + "</div>")
        wrapped.find('title').remove()
        wrapped.find('style').remove()
        wrapped.find('head').remove()
        console.error wrapped.html().stripTags().unescapeHTML().trim() if console && console.error
        true

    false
  true
