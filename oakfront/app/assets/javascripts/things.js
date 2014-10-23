function isFloat(n) {
    return n === +n && n !== (n|0);
}
var _product_watched;
var _store_blacklisted;
jQuery(document).ready(function() {
  jQuery("abbr.timeago").timeago();

  $.cookieBar({
    fixed: true,
    zindex: 9999
  });
  $('.datatable').dataTable({
    "sPaginationType": "bootstrap"
  });

  $(".ask-product").click(function(e) {
    e.preventDefault();
    if(!current_user) {
      alert('Sorry, to use this feature you should be logged in!');
      return;
    }

    window.location.href="/new_store_ticket?id="+$(this).data('sid');
  });

  $(".reply-button").click(function(e) {
    e.preventDefault();
    msg = $(this).parent().prev().text().trim();
    var arr = msg.split('\n');
    for (var i = 0; i < arr.length; i++) 
      arr[i] = ">> " + arr[i];
    msg = arr.join('\n');
    msg += "\n\n";
    replyto = $(this).data('replyto');
    $("#recipient").val(replyto);
    $("#message").focus();
    $("#message").val(msg);
  });

  /** Store Blacklist **/
  $("#btn-blacklist-store").click(function(e) {
    e.preventDefault();
    if(!current_user) {
      alert('Sorry, to use this feature you should be logged in!');
      return;
    }
    var btn = $(this);
    var pid = $(this).data('sid');

    var onSuccessList = function() {
      btn.html("Remove from Blacklist");
      _store_blacklisted = true;
    };

    var doList = function() {
      btn.html("loading...");
      $.ajax({
        url:"/add_to_blacklist/".concat(pid),
        success: onSuccessList
      });
    };

    var onSuccessUnlist = function() {
      btn.html("Blacklist");
      _store_blacklisted = false;
    };

    var doUnlist = function() {
      btn.html("loading...");
      $.ajax({
        url:"/remove_from_blacklist/".concat(pid),
        success: onSuccessUnlist
      });
    };


    if(_store_blacklisted == true)
      doUnlist();
    else
      doList();

  });

  /** watch product **/
  $("#btn-watch-product").click(function(e) {
    e.preventDefault();
    if(!current_user) {
      alert('Sorry, to use this feature you should be logged in!');
      return;
    }
    var btn = $(this);
    var pid = $(this).data('pid');
    console.log("pid");
    console.log(pid);
    var unwatch = function() {
      btn.html('Loading...');
      btn.addClass('disabled');
      watchUrl = "/unwatch_product/".concat(pid);
      $.ajax({
        url: watchUrl,
        success: onSuccessUnwatch
      });
    };

    var onSuccessUnwatch = function(data) {
      btn.html('<i class="glyphicon glyphicon-eye-open"></i> Watch this Product');
       btn.removeClass('disabled');
       _product_watched = false;
    };

    var watch = function() {
      btn.html('Loading...');
      btn.addClass('disabled');
      console.log(pid);
      watchUrl = "/watch_product/".concat(pid);
      $.ajax({
        url: watchUrl,
        success: onSuccessWatch
      });
    };

    var onSuccessWatch = function(data) {
      btn.html('<i class="glyphicon glyphicon-eye-close"></i> Unwatch this Product');
      btn.removeClass('disabled');
      _product_watched = true;
    };

    if(_product_watched == true)
      unwatch();
    else
      watch();
  });

  /** compare products **/
  $("#compare-btn").click(function(e) {
  	var to_compare = [];
  	$(".compare-checkbox:checked").each(function() {
  		to_compare.push($(this).val());
  	});
  	console.log(to_compare);
  	if(to_compare.length == 0) {
  		alert('Nothing to compare!');
  		return;
  	}
  	if(to_compare.length == 1) {
  		alert("Can't compare only one product!");
  		return;
  	}
    if(!current_user && to_compare.length > 2) {
      alert("Only registered user can compare more than 2 products!");
      return;
    }

  	if(to_compare.length > 5) {
  		alert('You can compare maximally 5 products at time!');
  		return;
  	}

  	var url = "/products_compare/"+to_compare.join("/");
  	var onSuccess = function(data) {
  		$("#popup-title").html("Comparision results");
  		$("#popup-content").html(data);
  		$('#popup').modal('show');
  	};
  	$.ajax({
  		url: url,
  		success: onSuccess
  	});

  });

  /** write review **/
  $("#add-new-review").click(function(e) {
    if(!current_user) {
      alert('Sorry, to use this feature you should be logged in!');
      return;
    }

    var pid = $(this).data('pid');
    form ='<div class="row"><div class="col-md-12"><form id="review-form" method="post" action="/product/add_review">';
    form+='<div id="review-form-errors" class="errors"></div>';
    form+='<input type="hidden" name="pid" value="'+pid+'">';
    form+='<input type="hidden" name="authenticity_token" value="'+_oak_token+'">';
    form+='<input type="hidden" name="rating" id="rating_input">';
    form+='<div class="form-group"><label>Review:</label><textarea class="form-control" name="review_txt"></textarea></div>';
    form+='<div class="form-group"><label>Rating:</label><div id="rating" class="form-control"></div></div>';
    form+='<button id="submit-review" type="submit" class="btn btn-success">Save review</button>';
    form+='</form></div></div>';
    $("#popup-title").html("Add review");
    $("#popup-content").html(form);
    $("#rating").raty({path:'/stars', width: 'false', number: 6, 
    click: function(score, e) {
      $("#rating_input").val(score);
    }});

    $("#submit-review").click(function(e) {
      //parse data
      e.preventDefault();
      $("#review-form-errors").html('');
      rating = $('input[name="rating"]').val();
      review_txt = $('textarea[name="review_txt"]').val();
      errors = [];

      if(rating.trim().length == 0)
        errors.push("Rating can't be empty!");

      if(isNaN(rating) && errors.length == 0)
        errors.push("Rating is not a number!");

      if(rating < 0 && errors.length == 0)
        errors.push("Rating is less than 0!");

      if(rating > 6 && errors.length == 0)
        errors.push("Rating is bigger than 6!");

      if(review_txt.trim().length == 0)
        errors.push("Review is too short!")
      
      if(review_txt.length > 2000)
        errors.push("Review is too long: max length is 2000 characters!");

      if(errors.length > 0) {
        errStr="";
        for(i=0; i<errors.length;i++) {
          errStr+=errors[i];
          errStr+="<br>";
        }
        $("#review-form-errors").html(errStr);
        return;
      }

      $("#review-form").submit();

    });

    $("#popup").modal('show');
  });

});