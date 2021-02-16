$(document).on('turbolinks:load', () => {
  $('.vote-up').on('click', (e) => {
    const parentDiv = $(e.target).parents('div')
    const parentId = parentDiv.prop('id')

    if ($('#' + parentId + '>.vote-up').hasClass('voted')) {
      vote('unvote', parentDiv.data('resource'), parentDiv.data('resourceId'))
      $('#' + parentId + '>.vote-up').removeClass('voted')
      $('#' + parentId + '>.vote-up svg').attr('fill', 'lightgray')
    } else {
      vote('vote_up', parentDiv.data('resource'), parentDiv.data('resourceId'))
      $('#' + parentId + '>.vote-up').addClass('voted')
      $('#' + parentId + '>.vote-down').removeClass('voted')
      $('#' + parentId + '>.vote-up svg').attr('fill', 'black')
      $('#' + parentId + '>.vote-down svg').attr('fill', 'lightgray')
    }
  })

  $('.vote-down').on('click', (e) => {
    const parentDiv = $(e.target).parents('div')
    const parentId = parentDiv.prop('id')
    
    if ($('#' + parentId + '>.vote-down').hasClass('voted')) {
      vote('unvote', parentDiv.data('resource'), parentDiv.data('resourceId'))
      $('#' + parentId + '>.vote-down').removeClass('voted')
      $('#' + parentId + '>.vote-down svg').attr('fill', 'lightgray')
    } else {
      vote('vote_down', parentDiv.data('resource'), parentDiv.data('resourceId'))
      $('#' + parentId + '>.vote-up').removeClass('voted')
      $('#' + parentId + '>.vote-down').addClass('voted')
      $('#' + parentId + '>.vote-up svg').attr('fill', 'lightgray')
      $('#' + parentId + '>.vote-down svg').attr('fill', 'black')
    }
  })
})

const vote = (action, resource, id) => {
  $.ajax({
    type: action === 'unvote' ? 'DELETE' : 'POST',
    url: `/${resource}s/${id}/${action}`,
    success: data => {
      $(`#vote-${resource}-${id} p`).html(data.total_votes)
    },
    error: data => {
      console.log(data)
    }
  })
}