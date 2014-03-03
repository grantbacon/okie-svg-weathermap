#!/usr/bin/python
import urllib2

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
	if line[0] == "STID":
		continue
	data = line.split(",")
	if len(data) > 1:
		#get data out of the Lat Long and Temp locations
		lat = data[3]
		lon = data[4]
		#print "The latitude is: " + lat
		#print "The longitude is: " + lon
		temp = data[10]
		if temp == " ":
			temp = "-1"
		#print "the temperature is: " + temp
		formatedLines += lat + "," + lon + "," + temp + "\n"

print formatedLines
print "done printing"

