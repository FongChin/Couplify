// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$('document').ready(function(){
  $('#edit-couple-form').on('submit', function(event){
    event.preventDefault();
    var attribute = $('#edit-couple-form').serializeJSON();
    console.log(attribute);
    $('#profile-name-error-div').addClass('hidden');
    $('#profile-name-form-div').removeClass('has-error');
    $.ajax({
      type: "PUT",

      url: $('#edit-couple-form').attr('action'),

      data: attribute,

      success: function(data, textStatus, jqXHR){
        console.log(data);
        // change data
        $('#anniversary-date').text(data.anniversary_date)
        $('#edit-couple-info').modal('hide');
        if (data.profile_name && attribute.old_profile_name !== data.profile_name){
          window.location = window.location.origin + "/couples/" + data.profile_name;
        }
      },

      error: function(jqXHR){
        console.log("request failed");
        console.log(jqXHR.responseJSON.errors.profile_name);
        var profile_name_errors = jqXHR.responseJSON.errors.profile_name
        $.each(profile_name_errors, function(index, error_msg){
          $('#profile-name-error-msg').text("profile name " + error_msg);
        });
        $('#profile-name-error-div').removeClass('hidden');
        $('#profile-name-form-div').addClass('has-error');
      }
    });
  });
  
});
