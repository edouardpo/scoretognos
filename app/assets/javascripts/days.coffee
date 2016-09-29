$(document).on 'ready ajaxComplete page:load', ->
  $('#day-selector').on 'change', ->
    window.location.href = this.value
    return

  $(".view-bets-trigger-container a").click ->
    container = $(this).parent().closest('.row')
    $(this).parent().closest('div').hide()
    container.find(".hide-bets-trigger-container").show()
    container.find(".bets-container").fadeIn()

  $(".hide-bets-trigger-container a").click ->
    container = $(this).parent().closest('.row')
    container.find(".bets-container").fadeOut()
    $(this).parent().closest('div').hide()
    container.find(".view-bets-trigger-container").show()

  $(".edit-bet-trigger-container a").click ->
    container = $(this).parent().closest('.row')
    container.find(".bet-details").hide()
    container.find(".edit-bet-trigger-container").hide()
    container.find(".edit-bet-form-container").show()

  $('.bet-form .result-select').on 'change', ->
    form = $(this).parent().closest('.bet-form')
    if this.value == 'draw'
      form.find(".winner-fields-container").hide()
    else
      form.find(".winner-fields-container").show()




