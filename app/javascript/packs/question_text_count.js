document.addEventListener('DOMContentLoaded', () => {
  const maxCount = 200
  const inputArea = document.getElementById('question_body')
  const counter = document.getElementById('question_counter')
  let inputCharCount = inputArea.value.length || 0
  counter.innerHTML = maxCount - inputCharCount

  inputArea.onkeyup = () => {
    let inputCharCount = inputArea.value.length || 0
    counter.innerHTML = maxCount - inputCharCount
    if (maxCount - inputCharCount < 0) {
      counter.style.color = '#fdad10'
    } else {
      counter.style.color = '#ccc'
    }
  }
})
