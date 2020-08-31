import consumer from "./consumer"
import sanitizeHTML from "../utilities/sanitizeHTML"

$(document).on('turbolinks:load', () => {
  const questionId = $('.question').attr('data-question-id')  
  consumer.subscriptions.create({ channel: "AnswersChannel", question_id: questionId }, {
    connected() {
      // Called when the subscription is ready for use on the server
    },
  
    disconnected() {
      // Called when the subscription has been terminated by the server
    },
  
    received(data) {
      // Called when there's incoming data on the websocket for this channel
      if (gon.user_id != data.user_id) {
        $('.answers__list').append(`
          <li class='answer' id="answer-${data.id}">
            <p class='answer__body'>${sanitizeHTML(data.body)}</p>
          </li>
        `)
      }
    }
  });
})
