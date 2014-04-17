Team Zuse Weather Maps
======================

This application is the result of a 2014 undergraduate capstone project at the University of Oklahoma. This project uses 3rd party weather data collected from [Mesonet](http://mesonet.org) and the [National Weather Service](http://weather.gov) to create a colored weather-map in SVG format.

Our design uses a Delaunay triangulation to determine triangles of influence created by the obtained data points. Coloration is done using SVG composited linear gradients (barycentric interpolation would be ideal, but is not supported by SVG currently)


Installation Instructions
-------------------------

Requirements

+ Python (version 2.7.3 suggested)
+ ProofPad (to build binary)
+ A web browser (chrome only (svg gradient difficulties in firefox))

Instructions

1. Use ProofPad to build a binary executable from Delaunay.lisp and save this binary in the /webservice directory with the name 'mapgen'
2. Open a terminal and traverse to the /webservice directory
3. Run `python web_ui.py`
4. Use a web browser to connect to http://localhost:8081/



Team Zuse Members
==================

+ Grant Bacon - @grantbacon
+ Bryan Cain - @Plombo
+ Joel Maupin - @jmaupin82
+ Robert Wenrich - @rwenrich
+ Paul Wright - @mithraz87


