@init_afisha_extend = () ->
  if window.location.hash == '#photogallery' && $.fn.scrollTo
    setTimeout ->
      $.scrollTo($('.afisha_show .photogallery'), 500, { offset: {top: -50} })
      true
    , 300
  if window.location.hash == '#trailer' && $.fn.scrollTo
    setTimeout ->
      $.scrollTo($('.afisha_show .trailer'), 500, { offset: {top: -60} })
      true
    , 300
  true

@init_afisha_tabs = () ->
  $('#events_filter').tabs()

@init_afisha_social_actions = () ->

  #$('.social_actions .acts_as_inviter').click()

  $('.social_actions').on 'ajax:success', (evt, response, status, jqXHR) ->
    target = $(evt.target)

    if $('.social_signin_links', $(response)).length
      $('.cloud_wrapper', target.closest('.social_actions')).remove()
      signin_container = $('<div class="sign_in_with" />').appendTo('body').hide().html(response)
      signin_container.dialog
        autoOpen: true
        draggable: false
        modal: true
        resizable: false
        title: 'Необходима авторизация'
        width: '500px'

      init_auth()

      return false

    if target.hasClass('change_visit')
      target = $(evt.target).closest('.social_actions')
      target.html(response)

    if target.hasClass('acts_as_inviter')
      container = $('<div class="inviter_form_wrapper" />').appendTo('body').hide().html(response)
      form = $('form', container)
      radio_buttons_block = $('.radio_buttons', form)

      $('label', radio_buttons_block).each ->
        $(this).addClass($('input', this).attr('id'))
        $(this).addClass('checked') if $('input', this).is(':checked')
        $(this).click ->
          return false if $(this).hasClass('checked')
          $('label', radio_buttons_block).removeClass('checked')
          $(this).addClass('checked') if $('input', this).is(':checked')
          true

        true

      $.fn.initialize_invite = () ->
        list = $('.accounts_list', this)
        $('li .details .invite', list).each ->
          $(this).click ->

            false
        true

      $.fn.initialize_pagination = () ->
        page = 1
        busy = false
        list = $('.accounts_list', this)
        pagination = $('.pagination', this)
        next_link = $('.next a', pagination)

        list.jScrollPane
          autoReinitialise: true
          verticalGutter: 0
          showArrows: true

        block_offset = $('li:last', list).outerHeight(true, true) * ($('li', list).length - 3) - $('.jspContainer', list).outerHeight(true, true)
        if next_link.length
          list.bind 'jsp-scroll-y', (event, scrollPositionY, isAtTop, isAtBottom) ->
            if block_offset < scrollPositionY && !busy
              busy = true
              $.ajax
                url: next_link.attr('href')
                success: (response, textStatus, jqXHR) ->
                  return true if response.match(/empty_items_list/)
                  return true if response.trim().isBlank()
                  wrapped = $("<div>#{response}</div>")
                  $('.jspPane', event.target).append($('.accounts_list li', wrapped))
                  pagination.html($('.pagination', wrapped).html())
                  next_link = $('.next a', pagination)
                  block_offset = $('li:last', event.target).outerHeight(true, true) * ($('li', event.target).length - 3) - $('.jspContainer', list).outerHeight(true, true)
                  busy = false
                  true
                error: (jqXHR, textStatus, errorThrown) ->
                  wrapped = $("<div>#{jqXHR.responseText}</div>")
                  wrapped.find('title').remove()
                  wrapped.find('style').remove()
                  wrapped.find('head').remove()
                  console.error wrapped.html().stripTags().unescapeHTML().trim() if console && console.error
                  true

            true
        true

      $.fn.initialize_filter = () ->
        block = $(this)
        $('.filter a', block).each ->
          $(this).click ->
            link_wrapper = $(this).closest('li')
            return false if link_wrapper.hasClass('selected')
            $.ajax
              url: $(this).attr('href')
              success: (response, textStatus, jqXHR) ->
                wrapped = $("<div>#{response}</div>")
                $('.accounts_list', block).remove()
                $('.accounts_list', wrapped).appendTo(block)
                $('.pagination', block).remove()
                $('.pagination', wrapped).appendTo(block)
                link_wrapper.siblings().removeClass('selected')
                link_wrapper.addClass('selected')
                $('#q', block).val('')
                block.initialize_pagination()
                true
              error: (jqXHR, textStatus, errorThrown) ->
                wrapped = $("<div>#{jqXHR.responseText}</div>")
                wrapped.find('title').remove()
                wrapped.find('style').remove()
                wrapped.find('head').remove()
                console.error wrapped.html().stripTags().unescapeHTML().trim() if console && console.error
                true

            false

          true

        true

      $.fn.initialize_search = () ->
        block = $(this)
        $('form', block).on 'submit', ->
          form = $(this)
          return false unless $('#q', block).val()
          $.ajax
            url: form.attr('action')
            data: form.serialize()
            success: (response, textStatus, jqXHR) ->
              wrapped = $("<div>#{response}</div>")
              $('.accounts_list', block).remove()
              $('.accounts_list', wrapped).appendTo(block)
              $('.pagination', block).remove()
              $('.pagination', wrapped).appendTo(block)
              $('.filter li', block).removeClass('selected')
              block.initialize_pagination()
              true
            error: (jqXHR, textStatus, errorThrown) ->
              wrapped = $("<div>#{jqXHR.responseText}</div>")
              wrapped.find('title').remove()
              wrapped.find('style').remove()
              wrapped.find('head').remove()
              console.error wrapped.html().stripTags().unescapeHTML().trim() if console && console.error
              true
          false

        true

      container.dialog
        autoOpen: true
        draggable: false
        modal: true
        resizable: false
        title: 'Хочу пригласить'
        width: 780
        create: (event, ui) ->
          $('body').css
            overflow: 'hidden'
          true
        open: (event, ui) ->
          block = $('.right', this)
          block.initialize_pagination()
          block.initialize_filter()
          block.initialize_search()
          block.initialize_invite()
          true
        beforeClose: (event, ui) ->
          $("body").css
            overflow: 'inherit'
          true
        close: (event, ui) ->
          $(this).dialog('destroy')
          $(this).remove()
          true

      $('.submit_dialog', form).click ->
        container.dialog('close')

        $('.message_wrapper')
          .replaceWith('<div class="message_wrapper">Приглашение успешно отправлено!</div>')
          .delay(5000)
          .slideUp('slow')

        false

    if target.hasClass('acts_as_invited')
      target = $(evt.target).closest('.social_actions')
      target.html(jqXHR.responseText)

    if target.hasClass('invite')
      invite_container = $('<div class="invite_message_form_wrapper" />').appendTo('body').hide().html(response)
      form = $('form', invite_container)
      invite_container.dialog
        autoOpen: true
        draggable: false
        modal: true
        resizable: false
        title: 'Приглашение'
        width: '500px'

      $('.submit_dialog', form).click ->
        invite_container.dialog('close')

        $('.message_wrapper')
          .replaceWith('<div class="message_wrapper">Приглашение успешно отправлено!</div>')
          .delay(5000)
          .slideUp('slow')

        false

