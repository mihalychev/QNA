$(document).on('turbolinks:load', () => {
  $('.edit-answer').on('click', function(e) {
    e.preventDefault()
    $(this).addClass('hidden')
    const answerId = $(this).data('answerId')
    $('#answer-' + answerId + '-content').addClass('hidden')
    $('form#edit-answer-' + answerId).removeClass('hidden')
  })

  $('.edit-answer-close').on('click', function(e) {
    e.preventDefault()
    const answerId = $(this).data('answerId')
    $('form#edit-answer-' + answerId).addClass('hidden')
    $('#answer-' + answerId + '-content').removeClass('hidden')
    $('.edit-answer[data-answer-id=' + answerId + ']').removeClass('hidden')
  })
})
