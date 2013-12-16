clone = (obj) ->
  return obj  if obj is null or typeof (obj) isnt "object"

  temp = new obj.constructor()
  for key of obj
    temp[key] = clone(obj[key])

  temp

beforeImageInsert = (h) ->
  textarea = $(h.textarea)

  before = textarea.val()[0...h.caretPosition]
  after = textarea.val()[(h.caretPosition + h.selection.length)...textarea.val().length]

  file_input = $('.upload_gallery_images #gallery_image_file')

  file_input.fileupload
    dataType: 'json'

    done: (e, data) ->
      url = data.result.files[0].url
      textarea.val("#{before}#{url}#{after}")

    fail: (e, data) ->
      message = data.jqXHR.responseText
      $('.message_wrapper').text(message).show().delay(5000).slideUp('slow')

markItUpSettings = ->
  settings = clone(mySettings)
  settings.beforeInsert = ''

  imageButton = {
    name:'Изображение'
    className: 'image_button'
    openWith: ''
    beforeInsert: (h) ->
      beforeImageInsert(h)
  }

  settings.markupSet.push(imageButton)

  settings

@init_my_posts = ->
  $('.markitup').markItUp(markItUpSettings())

  $('.image_button').click ->
    $('#gallery_image_file').focus().trigger('click')
