$(document).on('turbolinks:load', () => {
  $("#add-question-link")
    .data("association-insertion-method", 'after')
    .data("association-insertion-node", '#edit-question-body')

  $("#add-answer-link")
    .data("association-insertion-method", 'after')
    .data("association-insertion-node", '#answer-body')

  $('#edit-question').on('click', function(e) {
    e.preventDefault()
    $(this).addClass('hidden')
    $('#question-content').addClass('hidden')
    const questionId = $(this).data('questionId')
    $('form#edit-question-' + questionId).removeClass('hidden')
  })

  $('#edit-question-close').on('click', function(e) {
    e.preventDefault()
    const questionId = $(this).data('questionId')
    $('form#edit-question-' + questionId).addClass('hidden')
    $('#question-content').removeClass('hidden')
    $('#edit-question').removeClass('hidden')
  })

  $('#add-comment').on('click', function(e) {
    e.preventDefault()
    $(this).addClass('hidden')
    $('#add-comment-form').removeClass('hidden')
  })

  $('#add-comment-close').on('click', function(e) {
    e.preventDefault()
    $('#add-comment-form').addClass('hidden')
    $('#add-comment').removeClass('hidden')
  })

  $('.edit-comment').on('click', function(e) {
    e.preventDefault()
    $(this).addClass('hidden')
    const commentId = $(this).data('commentId')
    $('#comment-' + commentId + ' form').removeClass('hidden')
    $('#comment-' + commentId + ' .comment-body').addClass('hidden')
  })

  $('.edit-comment-close').on('click', function(e) {
    e.preventDefault()
    const commentId = $(this).data('commentId')
    $('#comment-' + commentId + ' form').addClass('hidden')
    $('#comment-' + commentId + ' .comment-body').removeClass('hidden')
    $('.edit-comment[data-comment-id=' + commentId + ']').removeClass('hidden')
  })
})