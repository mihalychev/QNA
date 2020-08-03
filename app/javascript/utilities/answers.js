$(document).on('turbolinks:load', () => {
  $('.answers__list').on('click', '.button_edit-answer', function(e) {
    e.preventDefault()
    $(this).hide()
    const answerId = $(this).data('answerId')
    $('form#edit-answer-' + answerId).removeClass('hidden')
  })
})
