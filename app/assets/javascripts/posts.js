(function(root){
  Couplify = root.Couplify = root.Couplify || {};
    
  Couplify.delete_post = function(postId, success){
    console.log('post deleting')
    $.ajax({
      type: 'DELETE',
      url: '/posts/' + postId,
      success: success
    })
  }
  

  
})(this);

$('#put-form').on('click', '.delete-preview', function(event){
  // make ajax request to remove the post from db
  event.preventDefault();
  var $postDiv = $($(event.target).parent());
  var postId = $(event.target).data('id');
  var success = function(){
    console.log("post deleted");
    $postDiv.remove();
  }
  Couplify.delete_post(postId, success);
});
