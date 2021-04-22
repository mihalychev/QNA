$(document).on('turbolinks:load', () => {
  $(".edit-answer-link")
    .data("association-insertion-method", 'after')
    .data("association-insertion-traversal", 'closest')
    .data("association-insertion-node", '.edit-answer-body')
  
  $("#add-answer-link")
    .data("association-insertion-method", 'after')
    .data("association-insertion-node", '#add-answer-body')

  $('.edit-answer').on('click', function(e) {
    e.preventDefault()
    $(this).parent().addClass('hidden')
    const answerId = $(this).data('answerId')
    $('#answer-' + answerId + '-content').addClass('hidden')
    $('form#edit-answer-' + answerId).removeClass('hidden')
    $('form#edit-answer-' + answerId + ' .direct-upload').remove()
    $('form#edit-answer-' + answerId + ' input[type="file"]').attr('disabled', false)
    $("#answer-" + answerId + "-attachments").addClass('invisible')
  })

  $('.edit-answer-close').on('click', function(e) {
    e.preventDefault()
    const answerId = $(this).data('answerId')
    $('form#edit-answer-' + answerId).addClass('hidden')
    $('#answer-' + answerId + '-content').removeClass('hidden')
    $('.edit-answer[data-answer-id=' + answerId + ']').parent().removeClass('hidden')
    $("#answer-" + answerId + "-attachments").removeClass('invisible')
  })
})
