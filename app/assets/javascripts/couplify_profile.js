(function(root){
  var Couplify = root.Couplify = root.Couplify || {};
  
  Couplify.delete_post = function(postId, success){
    $.ajax({
      type: 'DELETE',
      url: '/posts/' + postId,
      success: success
    })
  }
  
  Couplify.insertPosts = insertPosts = function(){
    var data = JSON.parse($('#bootstraped-posts-json').html());
    var postsTemplateCode = $('#posts-template').html();
    var postsTemplateFn = _.template(postsTemplateCode);

    var postTemplateCode = $('#post-template').html();
    var postTemplateFn = _.template(postTemplateCode);
    var renderedContent = postsTemplateFn({posts: data.posts, renderSubPost: postTemplateFn});

    $('#posts-div').html(renderedContent);
  }
  
  Couplify.insertNewPost = insertNewPost = function(data, isPrepend){
    var templateCode = $('#post-template').html();
    var templateFn = _.template(templateCode);
    var renderedContent = templateFn({post: data});
    console.log('rendering content');

    if (isPrepend){
      Couplify.$posts_container.prepend(renderedContent);
    } else {
      Couplify.$posts_container.append(renderedContent);
    }
    Couplify.$posts_container.imagesLoaded(function(){
      Couplify.$posts_container.masonry('reloadItems').masonry('layout');
    });
  }
  
  Couplify.subscribeToPusherChannel = subscribeToPusherChannel = function(){
    var pusher = new Pusher('b9960496cbe51f37c4fb');
    var channel = pusher.subscribe("couple_" + Couplify.COUPLE_ID);
    channel.bind('new_post_event', function(data) {
      insertNewPost(JSON.parse(data.post), true);
    });
  }
  
  Couplify.InfiniteScroll = InfiniteScroll = function(numLoads){
    this.numLoads = numLoads;
    this.coupleId = Couplify.COUPLE_ID;
    this.itemsPerPage = 20;
    this.totalPages = Math.ceil(Couplify.NUM_POSTS / this.itemsPerPage );
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
  
})(this);

var ready = function(){
  var infiniteScroll = new Couplify.InfiniteScroll(1);
  Couplify.insertPosts();
  Couplify.subscribeToPusherChannel();
  
  Couplify.$posts_container.masonry({
    itemSelector: '.post',
    isAnimated: true,
  });
  
  Couplify.$posts_container.imagesLoaded(function(){
    Couplify.$posts_container.masonry('reloadItems').masonry('layout');
  });
  
  $('#posts-div').on("click", '.delete-post', function(event){
    var $postDiv = $($(event.target).parent());
    var postId = $(event.target).data('id');
    var success = function(){
      console.log("post deleted");
      Couplify.$posts_container.masonry()
                               .masonry('remove', $postDiv)
                               .masonry();
    }
    Couplify.delete_post(postId, success);
  })
  
  $('#export-btn').hover(function(event){
    $('#export-btn').tooltip('show');
  });
  var callback = _.throttle(infiniteScroll.fetch.bind(infiniteScroll), 200);
  
  $(window).on("scroll", callback);
}

$('document').ready(ready);
$('document').on('page:load', ready);