$(document).on('change', 'input[name="user[admin]"]', function() {
  if ($(this).is(':checked')) {
    $('#user_password_field').removeClass('d-none');
  } else {
    $('#user_password_field').addClass('d-none');
  }
});
