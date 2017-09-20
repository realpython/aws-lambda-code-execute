// globals
const editor = ace.edit('editor');

$(function() {
  // configure ace editor
  editor.setTheme("ace/theme/monokai");
  editor.getSession().setMode("ace/mode/python");
  editor.setFontSize('14px');
});

// handle form submit
$('form').on('submit', (event) => {
  event.preventDefault();
  const answer = editor.getSession().getValue();
  const payload = { answer: answer };
  grade(payload);
});

// ajax request
function grade(payload) {
  $.ajax({
    method: 'POST',
    url: 'tbd',
    dataType: 'json',
    contentType: 'application/json',
    data: JSON.stringify(payload)
  })
  .done((res) => { console.log(res); })
  .catch((err) => { console.log(err); });
}
