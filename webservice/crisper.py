# -*- coding: utf8 -*-
from urllib2 import urlopen
from time import time, sleep
import threading
from subprocess import Popen

from os.path import dirname, abspath, join
import mez

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

    def __init__(self, stor_dir = ".", latest_file_time = 0, timeout = 300):
        threading.Thread.__init__(self)

        self.daemon = True

        self.latest_file_time = latest_file_time
        self.stor_dir = stor_dir
        self.timeout = timeout

        self.meso = mez.Mez()
        self.halt_event = threading.Event()

    # override Thread.join()
    def join(self, timeout=None):
        self.halt_event.set()
        threading.Thread.join(self, timeout)

    # called when thread is executed
    def run(self):
        while not self.halt_event.is_set():
            try:
                svg_data = self._generate_latest()
                self._store_data(svg_data)
            except IOError, i:
                print "[Error]: Unable to write to file. Check permissions of directory."
                raise
            except Exception, e:
                raise CrisperException("Failed in normal thread exceution", e)
        sleep(self.timeout)

    def _generate_latest(self):
        print "Generating latest..."
        data = self.meso.get_data()
        print "Should call a subprocess and generate an image...~"
        sleep(20)

    def _store_data(self, svg):
        pass


