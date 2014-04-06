# -*- coding: utf8 -*-
from urllib2 import urlopen
from time import time, sleep
from subprocess import Popen, PIPE
from os.path import dirname, abspath, join
import threading
import mez
import nws
import blender

def relative_path(suffix):
    return join(dirname(abspath(__file__)), suffix)

class CrisperException(Exception):
    def __init__(self, message, parent = None):
        self.message = message
        self.parent = parent

    def __str__(self):
        return repr(self.message)

class Crisper(threading.Thread):
    """
    Crisper - "Keeps Data Fresh"™

    Public State(s):
        latest_file_time int Unix timestamp representing the last time a file was stored

    Variables:
        stor_dir string Location to store saved SVG files
    """

    def __init__(self, stor_dir = ".", latest_file_time = 0, timeout = 300, results = None):
        threading.Thread.__init__(self)

        self.daemon = True

        self.latest_file_time = latest_file_time
        self.latest_temp_data = []
        self.stor_dir = stor_dir
        self.timeout = timeout
        self.results = results

        self.meso = mez.Mez()
        self.nws = nws.NWS()

    def run(self):
        while True:
	        try:
	            self._generate_latest()
	        except Exception, e:
                    print e
                raise CrisperException("Failed in normal thread exceution", e)
        sleep(self.timeout)

    def _generate_latest(self):
        (data, temps) = self.meso.get_data()
        data += self.nws.get_data()

        try:
            executable = relative_path("/tmp/tempcolor")
            acl2 = Popen(executable, stdout=PIPE, stdin=PIPE)
            temperatureMap = acl2.communicate(input = data)[0]
            result = blender.generateSVG(temperatureMap)
        except:
            print "Error opening subprocess"

        file_timestamp = self._store_data(result)
        if file_timestamp:
            self.latest_file_time = file_timestamp
            self.latest_temp_data = temps

        sleep(self.timeout)

    def _store_data(self, svg):
        now = str(int(time()))

        try:
            new_filename = relative_path(self.stor_dir) + "/" + now + '.svg'
            file = open(new_filename, 'w+')
            file.write(svg)
            file.close()
            self.latest_file_name = new_filename
        except IOError, i:
            print "Could not create file @" + now
            print i

        print "Created new file: " + now + ".svg"
        return now
