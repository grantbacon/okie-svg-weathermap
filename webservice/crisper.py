# -*- coding: utf8 -*-
from urllib2 import urlopen
from time import time, sleep
import threading
import os

class CrisperTimer(threading.Thread):
    def run(self):
        return

class Crisper(threading.Thread):
    """
    Crisper - "Keeps Data Fresh"™

    Public State(s):
        latest_file_time int Unix timestamp representing the last time a file was stored

    Variables:
        stor_dir string Location to store saved SVG files
    """

    def __init__(self, stor_dir = ".", latest_file_time = 0):
        self.latest_file_time = latest_file_time
        self.stor_dir = stor_dir
        # TODO: call timer to repeatedly run function
#        self.test_time()

    def test_time(self):


    def store_data(self, svg):
        return
"""

#Awesome crisper made by Joel the badass
print "about to call url"
response = urllib2.urlopen('http://www.mesonet.org/data/public/mesonet/current/current.csv.txt')
print "waiting for response"
body = response.read()
print "Print out each line of the file"
#break the data into lines

lines = body.split("\n")
formattedLines = ""
for line in lines:
	data = line.split(",")
	if len(data) >= 9:
		if data[0] == "STID":
			continue
		#get data out of the Lat Long and Temp locations
		lat = data[3]
		lon = data[4]
		#print "The latitude is: " + lat
		#print "The longitude is: " + lon
		temp = data[10]
		if temp == " ":
			continue
		#print "the temperature is: " + temp
		formattedLines += lat + "," + lon + "," + temp + "\n"

print formattedLines
print "done printing"

"""
