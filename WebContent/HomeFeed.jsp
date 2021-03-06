<!DOCTYPE html>
<html lang="en">
<head>
  <title>Home Feed User</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
  <link rel="stylesheet" href="guestfile.css" />
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
  	<script>
  	window.onload = function(){
  		var loggedin = <%=request.getSession().getAttribute("loggedin")%>;
  		console.log(loggedin);
  		if(loggedin===false || loggedin===null){
  			console.log("loggedin");
  			window.location = "GuestPage.jsp";
  		}
  	}
  	function logout(){
  		var xhttp = new XMLHttpRequest();
  		xhttp.open("GET", "Logout?", false); //synchronous
  		xhttp.send();
  		window.location.replace("GuestPage.jsp");	
  	}
    function validate() {
        console.log("here");
        var requeststr = "NewPost?";
        requeststr += "img="
                + document.getElementById("img").value;
        requeststr += "&description="
                + document.getElementById("description").value;
        requeststr += "&tag1="
            + document.getElementById("tag1").value;
        requeststr += "&tag2="
            + document.getElementById("tag2").value;
        requeststr += "&tag3="
            + document.getElementById("tag3").value;
        requeststr += "&tag4="
            + document.getElementById("tag4").value;
        requeststr += "&tag5="
            + document.getElementById("tag5").value;
        console.log(requeststr);
        var xhttp = new XMLHttpRequest();
        xhttp.open("POST", requeststr, false);
        xhttp.send();
        console.log(xhttp.responseText);

        if(xhttp.responseText.trim().length>0){
			console.log('post failed');
			document.getElementById("inputError").innerHTML = xhttp.responseText;
        }
        else{
        		console.log('post success');
         	$('#myModal').modal('hide');
        }
    }
</script>
</head>
<body>

<div class="container">
  	 <nav class="navbar navbar-inverse navbar-fixed-top">
    <div class="container-fluid">
      <div class="navbar-header">
        <a class="navbar-brand" href="TopRanked.jsp">DogSpotting</a>
      </div>
      <form method="GET" class="navbar-form navbar-left" action="Search.jsp">
        <div class="input-group">
          <input type="text" id="search" class="form-control"
            placeholder="Search" name="search">
          <div class="input-group-btn">
            <button class="btn btn-default" type="submit">
              <i class="glyphicon glyphicon-search"></i>
            </button>
          </div>
        </div>
      </form>
      <ul class="nav navbar-nav">
      <li><a type="button" data-toggle="modal" data-target="#myModal">+</a></li>
      <li><a href="TopRanked.jsp" type="button">Top</a></li>
      <li><a type="button" onclick="location.href='UserProfile.jsp'"><%=(String)session.getAttribute("currentusername")%></a></li>
      <li><a type="button" onclick="logout()">Log Out</a></li>
      </ul>
    </div>
  </nav>
	</div>
  <!-- Trigger the modal with a button -->

  <!-- Modal -->
  <div class="modal fade" id="myModal" role="dialog">
    <div class="modal-dialog">

      <!-- Modal content-->
   <div class="modal-content">
     <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal">&times;</button>
          <h1 class="modal-title">New Post</h1>
    </div>
     <div id="postform">
        <div class="modal-body">
  		Image URL:<input type="url" id="img" name="img"><br>
  		Caption:<input type="textarea" id="description" name="description"><br>
  		Tag 1:<input type="text" id="tag1" name="tag1"><br>
  		Tag 2:<input type="text" id="tag2" name="tag2"><br>
  		Tag 3:<input type="text" id="tag3" name="tag3"><br>
  		Tag 4:<input type="text" id="tag4" name="tag4"><br>
  		Tag 5:<input type="text" id="tag5" name="tag5"><br>
  		<span id="inputError" style="color: darkred; font-weight: bold"></span>
      </div>
      </div>
      <div class="modal-footer">
          <button type="button" id="closebutton" class="btn btn-default" data-dismiss="modal">Close</button>
          <button type="button" id="postbutton" class="btn btn-default" onclick="validate()">Post</button>
      </div>
    </div>
  </div>
    </div>

    <div class="container" style="padding-top: 70px">
  <div id="posts">
  </div>
  <div id="readMoreButton">
  <button class="btn btn-default" id="readMore">Read More</button>
  </div>
  </div>
  <br>
  <br>

<script>
var numOfPost = 0;
var postEachPage = 20;
var curCount = 0;

$(document).ready(function() {
  $("#readMore").click();
});
$("#readMore").on("click", function() {
  numOfPost += postEachPage;
  curCount = 0;
  $.post("HomeFeed", { username: "<%= request.getSession().getAttribute("currentusername") %>", limit: numOfPost }, function(responseJson) {
    $("#posts").empty();
    $.each(responseJson, function(index, post) {
      curCount++;
      $("#posts").append("<div class='container post thumbnail'><a href='PostPage?postID=" + post.postID + "'><img src='" + post.imageURL + "'></a></div>");
    });
    if (curCount <= numOfPost - postEachPage) {
      $("#readMoreButton").html("No more posts");
    }
  });
});
  
</script>
</body>
</html>
