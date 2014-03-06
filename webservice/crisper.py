# -*- coding: utf8 -*-
from urllib2 import urlopen
from time import time, sleep
import threading
import os
import mez

class CrisperTimer(threading.Thread):
    def run(self):

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
        return

    def store_data(self, svg):
        return
