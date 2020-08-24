$(document).on('turbolinks:load', () => {
  $('.vote__up, .vote__unvote, .vote__down')
  .on('ajax:success', e => {
    e.preventDefault()
    const vote = e.detail[0]
    $('.vote__value').html(vote.total_votes)
  })
  .on('ajax:error', e => {
    const error = e.detail[0]
    console.log(error)
  })

  $('.vote__up, .vote__down').on('click', () => {
    $('.vote__up, .vote__down').addClass('hidden')
    $('.vote__unvote').removeClass('hidden')
  })

  $('.vote__unvote').on('click', () => {
    $('.vote__up, .vote__down').removeClass('hidden')
    $('.vote__unvote').addClass('hidden')
  })
})