$(document).ready( function() {

  $("#user").keyup(function (e) {
    e.preventDefault();
    $.get('/edit_user/' + $(this).val(), function(data){
      $("#user_addresses").html(data);
      $('#origin_addresses').change(function() {
        $('#origin').val($('#origin_addresses :selected').val())
      });
      $('#destination_addresses').change(function() {
        $('#destination').val($('#destination_addresses :selected').val())
      });
    });
  })


  console.log("JS loaded");
})

