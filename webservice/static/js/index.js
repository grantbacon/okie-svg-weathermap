$(document).ready(function(){
	/* requests the temps from the web server and then updates the values of the labels in the svg. */
	function updateTemps(){
		//get the array of temps from python
		$.get("/latest/temps", function(data){
			var temps = $.parseJSON(data);
			console.log(data);
			
			//select each city temp label and put the temp value there. 
			var guymon = d3.select("#guymon-temp");
			guymon.text(temps.Goodwell);
			var tulsa = d3.select("#Tulsa-temp");
			tulsa.text(temps.Tulsa);
			var okc = d3.select("#Oklahoma-temp");
			okc.text(temps["Oklahoma City West"]);
			var lawton = d3.select("#Lawton-temp");
			lawton.text(temps.Apache);
			var ardmore = d3.select("#Ardmore-temp");
			ardmore.text(temps.Ardmore);
			var broken = d3.select("#Broken-temp");
			broken.text(temps['Broken Bow']);
			var enid = d3.select("#Enid-temp");
			enid.text(temps.Lahoma);
			var norman = d3.select("#Norman-temp");
			norman.text(temps.Norman);
			var Muskogee = d3.select("#Muskogee-temp");
			Muskogee.text(temps.Porter);
			var elk = d3.select('#Elk-temp');
			elk.text(temps.Erick);

			//now put those temps 
		});
	}

	//html content for the 1st segment of the segmented control
	var page1 = "<div class='well well-small' id='current-controls'><p>For current conditions the image to the left will be updated automatically.</p></div>";
	var page2 = "<div class='well well-small' id='historical-controls'><p>Put some controls here dummy</p></div>";

	/* Set the intial image to be the latest image available */
	$.get("/latest/image", function(img) {
		$('#imgbox').append(img.firstChild);
	});

	//hide the user controls depending on what button is selected in the segmented control
	$("#current-button").click(function(){
		//console.log("click event on current button");
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
		//console.log("click event on current button");
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


	updateTemps();
	/*
		Refresh the image on the page every min to see if the file name has changed. If it has, update the image. 
	*/
	setInterval(function(){
		//clear the current image
		$('#imgbox').empty();
		//get the most recent image data and put it inside imgbox
		$.get("/latest/image", function(img) {
		$('#imgbox').append(img.firstChild);
		updateTemps();
	});
	}, 60000);


});