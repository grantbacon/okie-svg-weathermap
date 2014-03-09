#!/usr/bin/python
# -*- coding: utf8 -*-
from bottle import run, route, request, template, static_file, response
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
    return crisp.latest_file_time

@route('/latest/image')
def latest_image():
    try:
        file = open(crisp.latest_file_name, 'r')
        image_data = file.read()
        file.close()
    except IOError, i:
        print "[ERROR]: " + i
        response.status = 500
        response.body = 'Error opening latest image'
        return

    response.set_header('Content-Type', 'image/svg+xml')
    response.body = image_data
    return image_data

try:
    crisp = Crisper(stor_dir = "svg_crisper", timeout = 300)
    crisp.start()
    run(host=ADDR, port=PORT)
except Exception, e:
    print e

