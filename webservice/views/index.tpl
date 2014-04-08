<!DOCTYPE html>

<html>
<head>
<title> Oklahoma Weather </title>
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
      <li class="active"><a href="/">Home</a></li>
      <li ><a href="/about">About Us</a></li>
      <li><a href="http://www.mesonet.org/">Oklahoma Mesonet</a></li>
    </ul>
  </div>
</div>
<div class='row-fluid'>
	<div class='span12'>
		<div class='page-header'>
		<h1> OK Weather Map Generator <small>Brought to you by Team Zuse</small></h1>
	</div>
	</div>
</div>
<div class='row-fluid'>
		<div class='span12' id='imgbox'>
		<!-- <img id='mainImage' src='./svg_crisper/1.svg' alt="weathermap-alt" height='260' width='520'/> -->
		</div>
	</div>
	<div class='row-fluid'>
		<div class='span4'>
		</div>
	<div style='margin:auto; text-align:center;' class='span4'>
		<h4>User Controls</h4>
		<br/><br/>
		<center>
		<div class='btn-group'>
			<button class='btn btn-large active' id='current-button'>Air Temperature</button>
			<button class='btn btn-large' id='historical-button'>Air Pressure</button>
		</div>
		</center>
		<br>
		<div class='divider'></div>
		<div id='segmented-control-content'>
			<div class="well well-small" id='current-controls'>
				<p>The temperature map will update automatically as long as this tab is selected.</p>
			</div>
		</div>
		<form></form>

	</div>
	<div class='span4'>
	</div>
</div>

<script type="text/javascript" src="http://code.jquery.com/jquery-1.8.3.min.js"></script>
<script type="text/javascript" src="/static/js/bootstrap.min.js"></script>
<script type="text/javascript" src="/static/js/d3.min.js"></script>
<script type="text/javascript" src="/static/js/index.js"></script>



</body>
</html>
