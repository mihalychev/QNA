$(document).on('turbolinks:load', () => {
  $('.question').on('click', '.button_edit-question', function(e) {
    e.preventDefault()
    $(this).hide()
    const questionId = $(this).data('questionId')
    $('form#edit-question-' + questionId).removeClass('hidden')
  })
})