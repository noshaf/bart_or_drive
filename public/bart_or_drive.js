$(document).ready( function() {
  console.log("hello");
  $("#user").keyup(function (e) {
    e.preventDefault();
    $.get('/edit_user/' + $(this).val(), function(data){
      $("#user_textbox_status").html(data);
    })
  })
})