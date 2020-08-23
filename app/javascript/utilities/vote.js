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
})