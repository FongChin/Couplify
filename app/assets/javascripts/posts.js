$(document).ready(function(){
  var previewTemplate = $('#preview-template').html();

  var fileAddedCallback = function (file, url){
    $('#dropzone-form').addClass('hidden');
  }

  var fileUploadSuccess = function(file, data, error){
    $(file.previewTemplate).find('.preview-post-body-textarea').attr('name', 'posts[' + data.id + '][body]');
    $(file.previewTemplate).find('.preview-post-id').attr('name', 'posts[' + data.id + '][id]');
    $(file.previewTemplate).find('.preview-post-id').attr('value', data.id);
    $(file.previewTemplate).find('.delete-preview').attr('data-id', data.id);
    $('#preview-posts').append(file.previewTemplate);
    $('#put-form').removeClass('hidden');
  }

  var fileProcessingCallback = function(){
    console.log("processing");
  }

  Dropzone.options.dropzoneForm = {
    previewTemplate: previewTemplate,
    parallelUploads: 10,
    autoProcessQueue: true,
    paramName: "post[image]",
    init: function(){
      this.on("thumbnail", fileAddedCallback);
      this.on("processing", fileProcessingCallback)
      this.on("success", fileUploadSuccess);
    }
  }

  $('#put-form').on('click', '.delete-preview', function(event){
    // make ajax request to remove the post from db
    event.preventDefault();
    var $postDiv = $($(event.target).parent());
    var postId = $(event.target).data('id');
    var isLastPost = ($postDiv.siblings().length == 0) ? true : false;
    var success = function(){
      $postDiv.remove();
      if (isLastPost){
        window.history.back();
      }
    }
    Couplify.delete_post(postId, success);
  });
  
  $('#dropzone-form').dropzone();
})