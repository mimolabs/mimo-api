$(document).ready(function() {
  $('.wizard').click(function(ev) {
    $('.wizard').hide()
    $('.success').html('<p><b>A code has been sent to the admin account!</b></p>');
  });
});
