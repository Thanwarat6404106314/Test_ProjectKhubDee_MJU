$('#visible-password').on('click', function(e) {
    e.preventDefault();
    var input = $('#password');
    var icon = $('#visible-password i');

    if (input.attr('type') === 'password') {
        input.attr('type', 'text');
        icon.addClass('fa-eye');
    } else {
        input.attr('type', 'password');
        icon.removeClass('fa-eye');
    }
});