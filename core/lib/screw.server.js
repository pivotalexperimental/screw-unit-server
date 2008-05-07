(function() {
  jQuery(Screw).bind('after', function() {
    var error_text = jQuery(".error").map(function(i, element) {
      return element.innerHTML;
    }).get().join("\n");

    var suite_id;
    if(top.runOptions) {
      suite_id = top.runOptions.getSessionId();
    } else {
      suite_id = 'user';
    }

    jQuery.post('/suites/' + suite_id + '/finish', {
      "text": error_text
    });
  });
})();
