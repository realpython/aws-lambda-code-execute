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
    url: 'https://c0rue3ifh4.execute-api.us-east-1.amazonaws.com/v1/execute',
    dataType: 'json',
    contentType: 'application/json',
    data: JSON.stringify(payload)
  })
  .done((res) => {
    let message = 'Incorrect. Please try again.';
    if (res) {
      message = 'Correct!';
    }
    $('.answer').html(message);
    console.log(res);
    console.log(message);
  })
  .catch((err) => {
    $('.answer').html('Something went terribly wrong!');
    console.log(err);
  });
}
