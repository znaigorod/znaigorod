@init_datetime_picker = () ->
  $('input.date_picker').datepicker
    changeMonth: true
    changeYear: true
    yearRange: "c-80:c+5"

  $('form').on 'nested:fieldAdded', (event) ->
    $(event.field).find('input.date_picker').removeClass('hasDatepicker').datepicker
      changeMonth: true
      changeYear: true

    true

  $('input.datetime_picker').datetimepicker
    changeMonth: true
    changeYear: true

  $('form').on 'nested:fieldAdded', (event) ->
    $(event.field).find('input.datetime_picker').removeClass('hasDatepicker').datetimepicker
      changeMonth: true
      changeYear: true

    true

  true
