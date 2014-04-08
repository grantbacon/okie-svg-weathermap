#!/usr/bin/python
# -*- coding: utf8 -*-
from bottle import run, route, request, template, static_file, response
from os.path import dirname, abspath, join
import subprocess, Queue
from crisper import Crisper
from json import dumps

ADDR='localhost'
PORT='8081'
STATIC_DIR='static'
IMAGE_DIR='svg_crisper'

def relative_path(suffix):
    return join(dirname(abspath(__file__)), suffix)

@route('/static/<filepath:path>')
def static(filepath):
    return static_file(filepath, root=relative_path(STATIC_DIR))

@route('/svg_crisper/<filepath:path>')
def static(filepath):
    return static_file(filepath, root=relative_path(IMAGE_DIR))

@route('/')
def index():
    return template('index')

@route('/about')
def about():
	return template('about')

@route('/latest/timestamp')
def latest_timestamp():
    return crisp.latest_file_time

@route('/latest/temps')
def latest_temps():
    return dumps(crisp.latest_temp_data)

@route('/latest/pressures')
def latest_temps():
    return dumps(crisp.latest_pressure_data)

@route('/latest/image/pressure')
def latest_image_pressure():
    try:
        file = open(crisp.latest_file_name_pressure, 'r')
        image_data = file.read()
        file.close()
    except IOError, i:
        print "[ERROR]: " + i
        response.status = 500
        response.body = 'Error opening latest pressure image'
        return

    response.set_header('Content-Type', 'image/svg+xml')
    response.set_header('Snapshot-Time', crisp.latest_file_time)
    response.body = image_data
    return image_data

@route('/latest/image/temp')
def latest_image_temp():
    try:
        file = open(crisp.latest_file_name, 'r')
        image_data = file.read()
        file.close()
    except IOError, i:
        print "[ERROR]: " + i
        response.status = 500
        response.body = 'Error opening latest temperature image'
        return

    response.set_header('Content-Type', 'image/svg+xml')
    response.set_header('Snapshot-Time', crisp.latest_file_time)
    response.body = image_data
    return image_data

try:
    crisp = Crisper(stor_dir = "svg_crisper", timeout = 300)
    crisp.start()
    run(host=ADDR, port=PORT)
except Exception, e:
    print e

