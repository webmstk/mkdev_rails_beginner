$ ->
  $('.decks_table').on 'change', 'input[name=current]', ->
    val = $(this).val()
    $.ajax
      url: '/decks/' + val + '/current',
      type: 'PUT',
      success: ->
      failure: ->
        alert 'Не получилось активировать колоду'
