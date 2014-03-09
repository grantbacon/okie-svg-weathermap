#!/usr/bin/python
# -*- coding: utf8 -*-
from bottle import run, route, request, template, static_file
from os.path import dirname, abspath, join
import subprocess, Queue
from crisper import Crisper

ADDR='localhost'
PORT='8085'
STATIC_DIR='static'

def relative_path(suffix):
    return join(dirname(abspath(__file__)), suffix)

@route('/static/<filepath:path>')
def static(filepath):
    return static_file(filepath, root=relative_path(STATIC_DIR))

@route('/')
def index():
    return template('index')

@route('/about')
def about():
	return template('about')

@route('/latest/timestamp')
def latest_timestamp():
    pass

try:
    crisp = Crisper()
    crisp.start()
    run(host=ADDR, port=PORT)
except KeyboardInterrupt:
    crisp.join()
