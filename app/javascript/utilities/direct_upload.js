$(document).on('turbolinks:load', () => {
  addEventListener("direct-upload:initialize", event => {
    const { target, detail } = event
    const { id, file } = detail
    target.insertAdjacentHTML("beforebegin", `
      <div id="direct-upload-${id}" class="direct-upload direct-upload--pending">
        <div id="direct-upload-progress-${id}" class="direct-upload__progress" style="width: 0%"></div>
        <span class="direct-upload__filename"></span>
      </div>
    `)
    target.previousElementSibling.querySelector(`.direct-upload__filename`).textContent = file.name
  })

  addEventListener("direct-upload:start", event => {
    const { id } = event.detail
    const element = document.getElementById(`direct-upload-${id}`)
    element.classList.remove("direct-upload--pending")
  })

  addEventListener("direct-upload:progress", event => {
    const { id, progress } = event.detail
    const progressElement = document.getElementById(`direct-upload-progress-${id}`)
    progressElement.style.width = `${progress}%`
  })

  addEventListener("direct-upload:error", event => {
    event.preventDefault()
    const { id, error } = event.detail
    const element = document.getElementById(`direct-upload-${id}`)
    element.classList.add("direct-upload--error")
    element.setAttribute("title", error)
  })

  addEventListener("direct-upload:end", event => {
    const { target, detail } = event
    const { id } = detail
    // target.value = null
    console.log(target.value)
    $('.' + $(target).data('model') + '-files').html('No file')
    const element = document.getElementById(`direct-upload-${id}`)
    element.classList.add("direct-upload--complete")
  })

  $("input[type='file']").on("change", function() {
    const model = $(this).data('model')
    $(this).siblings('.' + model + '-files').html(`${ [...this.files].length } File${ [...this.files].length > 1 ? 's' : '' }`);
  })
})