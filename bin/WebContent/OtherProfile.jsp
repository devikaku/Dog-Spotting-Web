<!DOCTYPE html>
<html lang="en">
<head>
<!-- make all the same functionality excpet the settings change to the follow/ unfollow-->
<!-- make button to redirect to own profile page -->
<title>Home Feed User</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
  <link rel="stylesheet" href="guestfile.css" />
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>

<script>

  function ImageExists(url){
	    var image = new Image();
	    image.src = url;
	    if (!image.complete) {
	    	console.log('bad image1')
	        return false;
	    }
	    else if (image.height == 0) {
	    	console.log('bad image2')
	        return false;
	    }

	    return true;
	}
  function validateImage(){
	  var exists = true; // ImageExists(document.getElementById("changeimage").value);
	  $.get(document.getElementById("changeimage").value)
	    .done(function() { 
	        console.log('exists');
	   // })
	  //if(exists == true){
		 console.log("settings button image");
	        var requeststr = "UpdateProfilePic?";
	        //requeststr += "username="
	          //      + document.getElementById("username").value;
	        requeststr += "&changeimage="
	                + document.getElementById("changeimage").value;
	     
	        console.log(requeststr);
	        var xhttp = new XMLHttpRequest();
	        xhttp.open("POST", requeststr, false);
	        xhttp.send();
	        console.log(xhttp.responseText);
	        if (xhttp.responseText.trim().length > 0) {
	            console.log('changing failed')
	            document.getElementById("image_err").innerHTML = xhttp.responseText;
	        } else {
	            console.log('changing image success')
	            //window.location = "UserProfile.jsp"
	           $("#settingsModal").modal('hide');
	        }
	  //} 
	  })
	  .fail(function() { 
	        console.log('failed');
	        console.log('image failed to load')
	          //window.location = "UserProfile.jsp"
			document.getElementById("image_err").innerHTML = "Error: could not find photo";
	    })
	}

  function validateUsername(){
		 console.log("settings button username");
	        var requeststr = "UpdateUsername?";
	        //requeststr += "username="
	          //      + document.getElementById("username").value;
	        requeststr += "&changeusername="
	                + document.getElementById("changeusername").value;
	     
	        console.log(requeststr);
	        var xhttp = new XMLHttpRequest();
	        xhttp.open("POST", requeststr, false);
	        xhttp.send();
	        console.log(xhttp.responseText);
	        if (xhttp.responseText.trim().length > 0) {
	            console.log('changing failed')
	            document.getElementById("username_err").innerHTML = xhttp.responseText;
	        } else {
	            console.log('changing username success')
	            //window.location = "UserProfile.jsp"
	            $("#settingsModal").modal('hide');
	        }
	}

  function validatePassword(){
		 console.log("settings button password");
	        var requeststr = "UpdatePassword?";
	        //requeststr += "username="
	          //      + document.getElementById("username").value;
	        requeststr += "&changepassword="
	                + document.getElementById("changepassword").value;
	        requeststr += "&retypepassword="
                + document.getElementById("retypepassword").value;
	     
	        console.log(requeststr);
	        var xhttp = new XMLHttpRequest();
	        xhttp.open("POST", requeststr, false);
	        xhttp.send();
	        console.log(xhttp.responseText);
	        if (xhttp.responseText.trim().length > 0) {
	            console.log('changing failed')
	            document.getElementById("password_err").innerHTML = xhttp.responseText;
	        } else {
	            console.log('changing password success')
	            $("#settingsModal").modal('hide');
	        }
	}


  
  window.onload = function(){
  		var loggedin = <%=request.getSession().getAttribute("loggedin")%>;	
  		console.log(loggedin);
  		if(loggedin===false){
  			console.log("loggedin");
  			window.location = "GuestPage.jsp";
  			
  		}
	}
  	function logout(){
  		var xhttp = new XMLHttpRequest();
  		xhttp.open("GET", "Logout?", true); //synchronous
  		xhttp.send();
  		window.location.replace("GuestPage.jsp");	
  	}

		//var validChoice; 
	 $(document).ready(function() {
		  $("#postsButton").on("click", function() {
			 var validChoice = true;
			  // should there be a limit to the amount of users shown?
			console.log("postButton working");
		    $.get("OtherProfile",  { username: "<%= request.getParameter("otherusername") %>"}, function(responseJson) {
		        	$("#posts").empty();
		        	var par = JSON.parse(responseJson.ownPosts);
		        //var par = $.parseJSON(responseJson.ownPosts);
		        	opts= '';
		        console.log("lol: " + responseJson.ownPosts);
		        	
		        	if(responseJson.ownPosts == "[]"){
		        		console.log("NULL posts");
		        	}
		       
		        	console.log("postButton parsing");
		        console.log("pastPosts: "  + par.description);
		        	$.each(par, function(index, item) {
		        		
		        		console.log("postButton creating tag");
		        		console.log("descrip: " +item.description + "postID:" + item.postID + "postImageurl:" + item.imageURL);
		        		opts += "<h4 class='modal-title'>Past Posts</h4><div class='container post thumbnail'> "+item.description+"<a href='PostPage?postID=" + item.postID + "'><img src='" + item.imageURL + "'></a></div>";
		                //$("#followers").append("<div class='container post thumbnail' style='padding-right: -110px'>" + item + "</div>");
		        }); 
		       
		        	postsView(true, opts, responseJson.ownPosts);
		        	console.log("postButton done appending");
		        // display one image
		    	});
		   });
		  });
		//var validChoice; 
	 $(window).on('load', function() {
			 var validChoice = true;
			  // should there be a limit to the amount of users shown?
			console.log("postButton onload");
		    $.get("OtherProfile",  { username: "<%= request.getParameter("otherusername") %>"}, function(responseJson) {
		        	$("#posts").empty();
		        	var par = JSON.parse(responseJson.ownPosts);
		        //var par = $.parseJSON(responseJson.ownPosts);
		        	opts= '';
		        	if(responseJson.ownPosts == "[]"){
		        		console.log("NULL posts");
		        	}
		        	console.log("postButton parsing");
		        console.log("pastPosts: "  + par.description);
		        	$.each(par, function(index, item) {
		        		console.log("postButton creating tag");
		        		console.log("descrip: " +item.description + "postID:" + item.postID + "postImageurl:" + item.imageURL);
		        		opts += "<h4 class='modal-title'>Past Posts</h4><div class='container post thumbnail'> "+"content: "+ item.description+"<a href='PostPage?postID=" + item.postID + "'><img src='" + item.imageURL + "'></a></div>";
		                //$("#followers").append("<div class='container post thumbnail' style='padding-right: -110px'>" + item + "</div>");
		        	});
		        	postsView(true, opts, responseJson.ownPosts);
		        	console.log("postButton done appending");
		        // display one image
		    	
		   });
		  });
	 
	 $(document).ready(function() {
		  $("#likedButton").on("click", function() {
			  var validChoice = false;
			$.get("OtherProfile", { username: "<%= request.getParameter("otherusername") %>"}, function(responseJson) {
	        	$("#liked").empty();
	        	var par = JSON.parse(responseJson.likePosts);
	        //var par = $.parseJSON(responseJson.ownPosts);
	        	opts= '';
	        	console.log("likedButton parsing");
	        console.log("likedPosts: "  + par.description);
	        	$.each(par, function(index, item) {
	        		console.log("likedButton creating tag");
	        		console.log("descrip: " +item.description + "postID:" + item.postID + "postImageurl:" + item.imageURL);
	        		opts += "<h4 class='modal-title'>Liked Posts</h4><div class='container post thumbnail'> "+item.description+"<a href='PostPage?postID=" + item.postID + "'><img src='" + item.imageURL + "'></a></div>";
	                //$("#followers").append("<div class='container post thumbnail' style='padding-right: -110px'>" + item + "</div>");
	        }); 
	        //	$("#liked").empty().append(opts)
	         postsView(false, opts, responseJson.likePosts);
	        	console.log("likedButton done appending");
	        	 // display one image
	    	});
	});
});
	 
	function postsView(validChoice,opts,item){
		if(item == "[]"){
			console.log("check FINAL")
			opts = "No Posts";
		}
		if(validChoice == true){
			console.log("11true");
		 	$("#posts").empty().append(opts)
		}
		if(validChoice == false){
			console.log("false");
		 	$("#posts").empty().append(opts)
		}
	} 
	
  //$(document).ready(function() {
  //$("#followersButton").on("click", function() {
	  $(document).on("click", "#followersButton", function() { 
	  // should there be a limit to the amount of users shown?
    $.get("OtherProfile",  { username: "<%= request.getSession().getAttribute("otherusername") %>"}, function(responseJson) {
        	$("#followers").empty();
       // 	responseJson = responseJson.followerUsernames.toString();
       	const str = JSON.stringify(responseJson.followerUsernames);
       	console.log(str);
     // "["bacon","letuce","tomatoes"]"

     console.log(JSON.parse(str));
       // var par = JSON.parse(str);
        var par = JSON.parse(responseJson.followerUsernames);
        
        	console.log("followers: "+ par);
        	opts= '';
        	var inputElement;
        	$.each(par, function(index, item) {
        		//opts += "<button onclick='otherProfile("+item+")'>" + item + "<button>";
        		//var str1 = String(item);
        		console.log("usernameinfollowers: " + this);
        		//inputElement1 = document.createTextNode(item);
        		inputElement2 = document.createElement("BR");
        		inputElement = document.createElement('button');
        		inputElement.innerHTML = item;
        		 console.log("CHECKING ITEM: "+ item);
        		  console.log("CHECKING OTHERUSERNAME: " + "<%=(String) session.getAttribute("currentusername")%>");
        		  var userVal = "<%=(String) session.getAttribute("currentusername")%>";
        		  console.log("CHECKING VAL: "+ userVal);
        		  if(item == userVal){
        			  console.log("WOKRFJ:KDFJ");
        		  }
        	//	inputElement.type = "button";
        		inputElement.addEventListener('click', function(){
				otherProfile(item);
				//console.log("********THIS blah WORKING");
				if(item == <%=session.getAttribute("currentusername")%>)
				  {
				  	//console.log("111111111111111111111111111111THIS IS WORKING");
				  	//window.location = "UserProfile.jsp";
				  }
				//opts += "<a type=\'button\' onclick=\'location.href='UserProfile.jsp'\'>"+str + "</a>";
        		});
        		//$("#followers").empty().append(inputElement)
        		document.getElementById("followers").appendChild(inputElement);
        		document.getElementById("followers").appendChild(inputElement1);
        		document.getElementById("followers").appendChild(inputElement2);
        		//document.getElementById("followers").appendChild(opts);
        		//opts += "<button type=\'button\' onclick=\'otherProfile(\'"+str1+"\');\'>" + this + "</button>";
        		//setUser(item);
                //$("#followers").append("<div class='container post thumbnail' style='padding-right: -110px'>" + item + "</div>");
        });    
    	});
   });
  //});
  
  $(document).ready(function() {
	  $("#followingButton").on("click", function() {
		  // should there be a limit to the amount of users shown?
	    $.post("OtherProfile",  { username: "<%= request.getSession().getAttribute("otherusername") %>"}, function(responseJson) {
	        	$("#following").empty();
	        	var par = JSON.parse(responseJson.followingUsernames);
	        	opts= '';
	        	$.each(par, function(index, item) {
	        		opts +="<div class='container post thumbnail' style='padding-right: -110px'>" + item + "</div>";
	        }); 
	        	$("#following").empty().append(opts)
	    	});
	   });
	  });
  function validateNewPost() {
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

      if(document.getElementById("img").value.trim().length == 0 || document.getElementById("description").value.trim().length == 0 ||
      		(document.getElementById("tag1").value.trim().length == 0||document.getElementById("tag2").value.trim().length == 0||
      				document.getElementById("tag3").value.trim().length == 0||document.getElementById("tag4").value.trim().length == 0||
      				document.getElementById("tag5").value.trim().length == 0)){
      		if(document.getElementById("img").value.trim().length == 0){
     		 	document.getElementById("inputError").innerHTML = xhttp.responseText;
     		 }
      		if(document.getElementById("description").value.trim().length == 0){
     		 	document.getElementById("inputError").innerHTML = xhttp.responseText;
     		 }
     		 if(document.getElementById("tag1").value.trim().length == 0||document.getElementById("tag2").value.trim().length == 0||
				document.getElementById("tag3").value.trim().length == 0||document.getElementById("tag4").value.trim().length == 0||
				document.getElementById("tag5").value.trim().length == 0){
      			document.getElementById("inputError").innerHTML = xhttp.responseText;
     		 }
      }
      else{
      		document.getElementById("inputCorrect").innerHTML = xhttp.responseText;
       	alert('Post Successful')
      		window.location = "HomeFeed.jsp"
      }
  }
  
  function otherProfile(str){ // make a XMLRequest to send the username of the otheruser
	  //var str = item;
	  console.log("str: " +str);
	  var validInput = false;
	  var userVal = "<%=(String) session.getAttribute("currentusername")%>"
	  if(str == userVal)
		  {
		  	console.log("77777777777777777777777777777777777777777777777THIS IS WORKING");
		  	validInput = true;
		  	window.location = "UserProfile.jsp?username="+"<%=(String) session.getAttribute("currentusername")%>";
		  }
	  if(validInput == false){
	  window.location = "OtherProfile.jsp?otherusername="+str;
	
	  console.log("other profile buton: " + str);
      var requeststr = "OtherProfile?";
      //var str = getUser();     
      //console.log("otherProfile: " + document.getElementById("otherusername").value);
      requeststr += "otherusername="
              + str;
     
      console.log(requeststr);
      var xhttp = new XMLHttpRequest();
      xhttp.open("POST", requeststr, true);
      xhttp.send();
      //window.location = "OtherProfile.jsp"
      console.log(xhttp.responseText);}
  }

  
</script>

<style>
.list-group {
	max-height: 300px;
	overflow-y: scroll;
}
</style>
</head>
<body>

	<div class="container">
		<span class="nav"> <img src="none"></img> <text>DogSpotting</text>
			<input type="text" id="search" placeholder="Search..">
			<button type="button" class="btn btn-default" data-toggle="modal"
				data-target="#myModal">+</button>
			<a type="button" class="btn btn-default" onclick="location.href='TopRanked.jsp'">Top</a>
			<a type="button" class="btn btn-default" onclick="location.href='UserProfile.jsp'">My Profile</a>
			<button type="button" class="btn btn-default" onclick="logout()">Log
				Out</button>
		</span> <br> <span class="tab" id="userInfo"> <img src="none"></img>
			<text><%=(String)session.getAttribute("otherusername") %></text>
			<button type="button" class="btn btn-default" class="tablinks" id="postsButton">Posts</button>
			<button type="button" class="btn btn-default" class="tablinks" id="likedButton">Liked</button>
			<button type="button" class="btn btn-default" class="tablinks" data-toggle="modal"
				data-target="#followersModal" id="followersButton">Followers</button>
			<button type="button" class="btn btn-default" class="tablinks" data-toggle="modal"
				data-target="#followingModal" id="followingButton">Following</button>
			<button type="button" class="btn btn-default" class="tablinks" data-toggle="modal"
				id="followButton">Follow</button>
		</span>
	</div>
	<!-- Trigger the modal with a button -->

	<!-- Modal -->
	<div class="modal fade" id="myModal" role="dialog">
		<div class="modal-dialog">

			<!-- Modal content-->
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					<h4 class="modal-title">New Post</h4>
				</div>
				<div class="modal-body">
					<form action="/action_page.php">
						<!-- <input type="file" name="pic" accept="image/*"><br> -->
						Image URL: <input type="text" id="img" name="img"><br> 
						Caption:<input type="text" id="description" name="description"></><br>
						Tag 1:<input type="text" id="tag1" name="tag1"></><br>
						Tag 2:<input type="text" id="tag2" name="tag2"></><br>
						Tag 3:<input type="text" id="tag3" name="tag3"></><br>
						Tag 4:<input type="text" id="tag4" name="tag4"></><br>
						Tag 5:<input type="text" id="tag5" name="tag5"></><br>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" id="close" class="btn btn-default"
						data-dismiss="modal">Close</button>
					<button type="button" id="post" class="btn btn-default"
						data-dismiss="modal" onclick="validateNewPost()">Post</button>
				</div>
			</div>

		</div>
	</div>


	<!-- Modal followers -->
	<div class="modal fade" id="followersModal" role="dialog">
		<div class="modal-dialog">
			<!-- Modal content-->
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					Followers
				</div>
				<div class="modal-body" >
				<div class="list-group" id="followers"></div>
				</div>
				<div class="modal-footer">
					<button type="button" id="close" class="btn btn-default"
						data-dismiss="modal">Close</button>
				</div>
			</div>
		</div>
	</div>

	<!-- Modal following -->
	<div class="modal fade" id="followingModal" role="dialog">
		<div class="modal-dialog">
			<!-- Modal content-->
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					Following
				</div>
				<div class="modal-body">
					<div class="list-group">
						<button type="button"
							class="list-group-item list-group-item-action" id="following"
							onclick="otherProfile()">
							<img>
						</button>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" id="close" class="btn btn-default"
						data-dismiss="modal">Close</button>
				</div>
			</div>
		</div>
	</div>

	<!-- Modal Settings -->
	<div class="modal fade" id="settingsModal" role="dialog">
		<div class="modal-dialog">
			<!-- Modal content-->
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					<h4 class="modal-title">Settings</h4>
				</div>
				<div id="changeform">
					<div class="modal-body">
						Image:<input type="text" id="changeimage" name="changeimage"></>
						<button type="button" class="btn btn-default"
							onclick="validateImage()">Save</button>
						<br> <span id="image_err"
							style="color: darkred; font-weight: bold"></span> <br>Change
						Username:<input type="text" id="changeusername"
							name="changeusername"></>
						<button type="button" class="btn btn-default"
							onclick="validateUsername()">Save</button>
						<br> <span id="username_err"
							style="color: darkred; font-weight: bold"></span> <br>Change
						Password:<input type="password" id="changepassword"
							name="changepassword"></> <br> Repeat Password:<input
							type="password" id="retypepassword" name="retypepassword"></>
						<button type="button" class="btn btn-default"
							onclick="validatePassword()">Save</button>
						<br> <span id="password_err"
							style="color: darkred; font-weight: bold"></span>
					</div>
					<div class="modal-footer">
						<button type="button" id="closelogin" class="btn btn-default"
							data-dismiss="modal">Close</button>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="container" style="padding-top: 70px">
		<div id="posts"></div>
	</div>
	<div class="container" style="padding-top: 70px">
		<div id="liked"></div>
	</div>
</body>
</html>