$(document).ready(function() {
	$('form.resolve-form .form-actions button.btn-primary').click(function() {
		$('form.resolve-form .form-actions .progress .bar').css(
			{'width': '100%'}
		);
	});
});