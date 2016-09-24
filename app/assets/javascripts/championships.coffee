$(document).on 'ready page:load', ->
  $('#join-modal').on 'show.bs.modal', (event) ->
    button = $(event.relatedTarget)
    championshipLink = button.data("championship-link")
    championshipName = button.data("championship-name")
    modal = $(this)
    modal.find('.modal-title').text championshipName
    modal.find('#join-championship-link').attr("href", championshipLink)
