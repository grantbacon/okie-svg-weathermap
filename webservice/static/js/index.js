$(document).ready(function(){
	/* requests the temps from the web server and then updates the values of the labels in the svg. */
	function updateTemps(){
		//get the array of temps from python
		$.get("/latest/temps", function(data){
			var temps = $.parseJSON(data);
			console.log("updateTemps has been called.");
			//select each city temp label and put the temp value there. 
			var guymon = d3.select("#guymon-temp");
			var temp = temps.Goodwell;
			if(temp == null)
				guymon.text(temps.Hooker);
			else
				guymon.text(temps.Goodwell);
			var tulsa = d3.select("#Tulsa-temp");
			temp = temps.Tulsa;
			if(temp == null)
				tulsa.text(temps.Claremore);
			else
				tulsa.text(temps.Tulsa);
			var okc = d3.select("#Oklahoma-temp");
			temp = temps["Oklahoma City West"];
			if(temp == null)
				okc.text(temps["Oklahoma City East"]);
			else
				okc.text(temps["Oklahoma City West"]);
			var lawton = d3.select("#Lawton-temp");
			temp = temps.Apache;
			if(temp == null)
				lawton.text(temps.Acme);
			else
				lawton.text(temps.Apache);
			var ardmore = d3.select("#Ardmore-temp");
			temp = temps.Tulsa;
			if(temp == null)
				ardmore.text(temps.Burneyville);
			else
				ardmore.text(temps.Ardmore);
			var broken = d3.select("#Broken-temp");
			broken.text(temps['Broken Bow']);
			temp = temps['Broken Bow'];
			if(temp == null)
				broken.text(temps.Idabel);
			else
				broken.text(temps["Broken Bow"]);
			var enid = d3.select("#Enid-temp");
			temp = temps.Lahoma;
			if(temp == null)
				enid.text(temps.Fairview);
			else
				enid.text(temps.Lahoma);
			var norman = d3.select("#Norman-temp");
			temp = temps.Norman;
			if(temp == null)
				norman.text(temps.Washington);
			else
				norman.text(temps.Norman);
			var Muskogee = d3.select("#Muskogee-temp");
			temp = temps.Erick;
			if(temp == null)
				Muskogee.text(temps.Claremore);
			else
				Muskogee.text(temps.Erick);
			var elk = d3.select('#Elk-temp');
			temp = temps.Erick;
			if(temp == null)
				elk.text(temps.Cheyenne);
			else
				elk.text(temps.Erick);

		});
	}

	//html content for the 1st segment of the segmented control
	var page1 = "<div class='well well-small' id='current-controls'><p>The temperature map will update automatically as long as this tab is selected.</p></div>";
	var page2 = "<div class='well well-small' id='historical-controls'><p>The pressure map will be updated automatically as long this tab is selected.</p></div>";

    var last_timestamp = 0;
	/* Set the intial image to be the latest image available */
        $.ajax({
            type: 'GET',
            url: '/latest/image',
            success: function(data, textStatus, request) {
                last_timestamp = request.getResponseHeader('Snapshot-Time');
                $('#imgbox').append(data.firstChild);
                updateTemps();
            }
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
        $.get('/latest/timestamp', function(ts) {
            if (ts != last_timestamp) {
                last_timestamp = ts;
                
                 $.ajax({
				            type: 'GET',
				            url: '/latest/image',
				            success: function(data, textStatus, request) {
                		last_timestamp = request.getResponseHeader('Snapshot-Time');
                		$('#imgbox').append(data.firstChild);
               			 updateTemps();
            				}
            				});
                
            }
            //updateTemps();
        });

	}, 10000);


});
