document.addEventListener('DOMContentLoaded', () => {
  const maxCount = 200
  const inputArea = document.getElementById('question_body')
  const counter = document.getElementById('question_counter')
  const rawValue = inputArea.value
  const crlf = rawValue.match(/(\r\n|\n|\r)/g)
  const crlfCount = crlf ? crlf.length : 0
  const inputCharCount = inputArea.value.length + crlfCount
  counter.innerHTML = maxCount - inputCharCount

  inputArea.onkeyup = () => {
    const rawValue = inputArea.value
    const crlf = rawValue.match(/(\r\n|\n|\r)/g)
    const crlfCount = crlf ? crlf.length : 0
    const inputCharCount = inputArea.value.length + crlfCount
    counter.innerHTML = maxCount - inputCharCount
    if (maxCount - inputCharCount < 0) {
      counter.style.color = '#fdad10'
    } else {
      counter.style.color = '#ccc'
    }
  }
})
