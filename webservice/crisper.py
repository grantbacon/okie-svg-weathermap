# -*- coding: utf8 -*-
from urllib2 import urlopen
from time import time, sleep
import threading
import os
import mez

class CrisperTimer(threading.Thread):
    def run(self):
        return

class Crisper:
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
        self.meso = mez.Mez()
        # TODO: call timer to repeatedly run function
        # self.test_time()
        return

    def test_time(self):
        result = self.meso.get_data()
        print result

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
formatedLines = ""
for line in lines:
	data = line.split(",")
	#get data out of the Lat Long and Temp locations
	lat = data[3]
	lon = data[4]

print "done printing"

"""
