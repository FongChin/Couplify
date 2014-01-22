var insertPosts = function(data){
  var data = JSON.parse($('#bootstraped-posts-json').html());
  var postsTemplateCode = $('#posts-template').html();
  var postsTemplateFn = _.template(postsTemplateCode);
  
  var postTemplateCode = $('#post-template').html();
  var postTemplateFn = _.template(postTemplateCode);
  var renderedContent = postsTemplateFn({posts: data.posts, renderSubPost: postTemplateFn});
  
  $('#posts-div').html(renderedContent);
}

var insertNewPost = function(data, isPrepend){
  var templateCode = $('#post-template').html();
  var templateFn = _.template(templateCode);
  var renderedContent = templateFn({post: data});
  console.log('rendering content');
   
  if (isPrepend){
    $posts_container.prepend(renderedContent);
  } else {
    $posts_container.append(renderedContent);
  }
  $posts_container.imagesLoaded(function(){
    $posts_container.masonry('reloadItems').masonry('layout');
  });
}

var subscribeToPusherChannel = function(){
  var pusher = new Pusher('b9960496cbe51f37c4fb');
  var channel = pusher.subscribe("couple_" + COUPLE_ID);
  channel.bind('new_post_event', function(data) {
    insertNewPost(JSON.parse(data.post), true);
  });
}

var InfiniteScroll = function(numLoads){
  this.numLoads = numLoads;
  this.coupleId = COUPLE_ID;
  this.itemsPerPage = 20;
  this.totalPages = Math.ceil(NUM_POSTS / this.itemsPerPage );
}

InfiniteScroll.prototype.fetch = function(){
  if ($(window).scrollTop() > ($(document).height() - $(window).height())){
    if (this.numLoads <= this.totalPages && this.totalPages != 1){
      var infiniteScroll = this;
      $.ajax({
        type: 'GET',
        url: '/couples/' + this.coupleId + '/posts/?page=' + this.numLoads,
        success: function(data){
          infiniteScroll.numLoads += 1;
        }
      })
    }
  }
}

InfiniteScroll.prototype.render = function(data){
  $.each(data, function(index, post){
    insertNewPost(post, false);
  });
}

$('document').ready(function(){
  var infiniteScroll = new InfiniteScroll(1);
  insertPosts();
  subscribeToPusherChannel();
  
  $posts_container.masonry({
    itemSelector: '.post',
    isAnimated: true,
  });
  
  $posts_container.imagesLoaded(function(){
    $posts_container.masonry('reloadItems').masonry('layout');
  });
  
  $('#posts-div').on("click", '.delete-post', function(event){
    var $postDiv = $($(event.target).parent());
    var postId = $(event.target).data('id');

    $.ajax({
      type: 'DELETE',
      url: '/posts/' + postId,
      success: function(){
        console.log("post deleted");
        $posts_container.masonry()
                        .masonry('remove', $postDiv)
                        .masonry();
      }
    })
  })
  
  var callback = _.throttle(infiniteScroll.fetch.bind(infiniteScroll), 200);
  
  $(window).on("scroll", callback);
});