import consumer from "./consumer"
import sanitizeHTML from "../utilities/sanitizeHTML"

$(document).on('turbolinks:load', () => {
  const questionId = $('.question').attr('data-question-id')  
  consumer.subscriptions.create({ channel: "CommentsChannel", question_id: questionId }, {
    connected() {
      // Called when the subscription is ready for use on the server
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      // Called when there's incoming data on the websocket for this channel
      
      const pattern = `
        <li class='comment' id="comment-${data.id}">
          <p class='comment__body'>${sanitizeHTML(data.body)}</p>
        </li>
      `

      if (gon.user_id != data.user_id) {
        if (data.commentable_type === 'Question') $(`.question-comments__list`).append(pattern)
        if (data.commentable_type === 'Answer') $(`#answer-comments-${data.commentable_id} > .answer-comments__list`).append(pattern)
      }
    }
  })
})
