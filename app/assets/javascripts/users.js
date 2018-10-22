// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function () {

  $codeBox = $("#codeBox");
  $msgBox = $("#somethingBox");

  function messageBox(state, message) {
    $msgBox.removeClass('is-hidden');
    $msgBox.find("article").attr("class", "message is-" + state);
    $msgBox.find(".message-body").html(message);
  }

  function check_mobile(query) {
    $.ajax({
      url: '/users/check_mobile',
      data: query,
      beforeSend: function () {
        $msgBox.addClass('is-hidden')
      },
      success: function (data) {
        $codeBox.removeClass('is-hidden');
        switch (data.message_code) {
          case 'CODE_EXPIRED_RESENT':
            messageBox('info', data.message);
            break;
          case 'CODE_VALID':
            messageBox('success', data.message);
            break;
          case 'CODE_INVALID':
            messageBox('danger', data.message);
            break;
          case 'IS_NEW_USER':
            messageBox('info', data.message);
            break;
          default:
            alert("default ran? 🤔");
            break;
        }
      },
      error: function (data) {
        messageBox('danger', data.responseText);
      },
    });
  }

  $("button").click(function (e) {
    pop_up = "submit mobile " + $('#mobile').val();
    if (!$('#code').val() == "") {
      pop_up += " with code " + $('#code').val() + "?";
    } else {
      pop_up += "?";
    }
    alert(pop_up);
    check_mobile({
      mobile: $('#mobile').val(),
      code: $('#code').val()
    });
  })

});