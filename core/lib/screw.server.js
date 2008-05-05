(function() {
  jQuery(Screw).bind('after', function() {
    var error_text = jQuery(".error").map(function(i, element) {
      return element.innerHTML;
    }).get().join("\n");

    var session_id;
    if(top.runOptions) {
      session_id = top.runOptions.getSessionId();
    }

    if(session_id) {
      jQuery.post('/suites/1/finish', {
        "session_id": session_id,
        "text": error_text
      });
    }
  });
})();
