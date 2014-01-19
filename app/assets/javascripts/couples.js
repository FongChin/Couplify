// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

var insertMessages = function(){
  var posts = JSON.parse($('#bootstraped_posts_json').html());
  var postsTemplateCode = $('#posts_template').html();
  var postsTemplateFn = _.template(postsTemplateCode);
  
  var postTemplateCode = $('#post_template').html();
  var postTemplateFn = _.template(postTemplateCode);
  
  var renderedContent = postsTemplateFn({posts: posts.posts, renderSubPost: postTemplateFn});
  
  $('#posts_div').html(renderedContent);
}

var insertNewMessage = function(data){
  var templateCode = $('#post_template').html();
  var templateFn = _.template(templateCode);
  var renderedContent = templateFn({post: data});
  
  $('#posts_div').prepend(renderedContent);
}

var subscribeToPusherChannel = function(){
  var pusher = new Pusher('b9960496cbe51f37c4fb');
  var channel = pusher.subscribe("couple_" + COUPLE_ID);
  
  channel.bind('new_post_event', function(data) {
    insertNewMessage(JSON.parse(data.post));
  });
}

$('document').ready(function(){

  insertMessages();
  
  subscribeToPusherChannel();
  
  $('#show-edit-couple-modal').on('click', function(event){
    $('#modal-anniversary-date').val(coupleAnniversaryDate);
    $('#modal-profile-name').val(coupleName);
    $('#edit-couple-info').modal('show');
  })
  
  $('#posts_div').on("click", '.delete_post', function(event){
    var $msgDiv = $(event.target).parent();
    var msgId = $(event.target).data('id');
    $.ajax({
      type: 'DELETE',
      url: '/messages/' + msgId,
      success: function(){
        console.log("post deleted");
        $msgDiv.remove();
      }
    })
  })
  
  $('#edit-couple-form').on('submit', function(event){
    event.preventDefault();
    var attribute = $('#edit-couple-form').serializeJSON();
    $('#profile-name-error-div').addClass('hidden');
    $('#profile-name-form-div').removeClass('has-error');
    
    $.ajax({
      type: 'PUT',
      url: $('#edit-couple-form').attr('action'),
      data: attribute,
      success: function(data, textStatus, jqXHR){
        // change data
        $('#anniversary-date').text(data.anniversary_date);
        $('#modal-anniversary-date').val(data.anniversary_date);
        $('#modal-profile-name').val(data.profile_name);
        
        $('#edit-couple-info').modal('hide');
        if (data.profile_name && attribute.old_profile_name !== data.profile_name){
          window.location = window.location.origin + '/couples/' + data.profile_name;
        }
        
      },
      error: function(jqXHR){
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
