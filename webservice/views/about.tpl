<!DOCTYPE html>

<html>
<head>
<title> About Us </title>
<link rel="stylesheet" type="text/css" href="/static/css/index.css" />
<link rel="apple-touch-icon" href="/static/apple-touch-icon.png" />
<link rel="shortcut icon" href="/static/favicon.ico" />
<link href="/static/css/bootstrap.min.css" rel="stylesheet"/>
</head>

<body>
	<div class='container'>
	<div class="navbar navbar-inverse">
  <div class="navbar-inner">
    <a class="brand" href="/">Zuse Weather Map</a>
    <ul class="nav">
      <li ><a href="/">Home</a></li>
      <li class="active"><a href="#">About Us</a></li>
      <li><a href="http://www.mesonet.org/">Oklahoma Mesonet</a></li>
    </ul>
  </div>
</div>
<div class='row-fluid'>
	<div class='span12' align='center'>
		<h1> OK Weather </h1>
	</div>
</div>
<div class='row-fluid'>
		<div class='span2'>
		</div>
	<div class='span8' align='center'>
	
				<h3>Overview</h3>
		<p>
Our goal is to create an ACL2 and web application that will allow the coloring of weather maps using publicly available data from the National Weather Service. This data consists of various information at specific geographic points. We will parse this data and use an ACL2 component to generate colors to correspond to the weather in between data points given from the National Weather Service. 
		</p>

			<h3>Software Features</h3>
			<p>
	The primary goal of our application will be to query weather data from the National Weather Service APIs, then using that data, populate a blank map with temperatures and colors corresponding to temperature. Then, update the front end user interface to display our newly generated map. The interface will attempt to be as minimalistic as possible thereby minimizing distraction from the actual product. While this interface will allow for little additional features outside of extra maps, the entire project is primarily a proof of concept before marketing to popular weather service companies. 
			</p>
			

	</div>
	<div class='span2'></div>
</div>
<div class='row-fluid'>
	<div class='span12'>
		<img src="./static/overview.png" alt="flowchart of our software">
	</div>

</div>

<script type="text/javascript" src="http://code.jquery.com/jquery-1.8.3.min.js"></script>
<script src="/static/js/bootstrap.min.js"></script>


</body>
</html>
