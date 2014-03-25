$(document).ready(function(){
	
	//html content for the 1st segment of the segmented control
	var page1 = "<div class='well well-small' id='current-controls'><p>For current conditions the image to the left will be updated automatically.</p></div>";
	var page2 = "<div class='well well-small' id='historical-controls'><p>Put some controls here dummy</p></div>";

	/* Set the intial image to be the latest image available */
	$.get("/latest/image", function(img) {
		$('#imgbox').append(img.firstChild);
	});

	//hide the user controls depending on what button is selected in the segmented control
	$("#current-button").click(function(){
		console.log("click event on current button");
		//if already active do nothing
		if($('#current-button').hasClass("active")){
			//do nothing
		}
		else{
			$('#current-button').addClass("active");
			$("#historical-button").removeClass("active");
			//reset the segmented control to be just page1
			$("#segmented-control-content").empty();
			$("#segmented-control-content").append(page1);
		}
	});

	//second segmented control button is clicked
	$("#historical-button").click(function(){
		console.log("click event on current button");
		//if already active do nothing
		if($("#historical-button").hasClass("active")){
			//do nothing
		}
		else{
			$("#historical-button").addClass("active");
			$("#current-button").removeClass("active");
			//reset the segmented control to be just page1
			$("#segmented-control-content").empty();
			$("#segmented-control-content").append(page2);
		}
	})



	/*
		Refresh the image on the page every min to see if the file name has changed. If it has, update the image. 
	*/
	setInterval(function(){
		
		$.get("/latest/image", function(img) {
		$('#imgbox').append(img.firstChild);
	});
	

	}, 60000);


});