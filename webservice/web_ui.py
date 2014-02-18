from bottle import run, route, request, template, static_file
import subprocess
import json
import os


ADDR='localhost'
PORT='8085'
STATIC_DIR='static'

def relative_path(suffix):
    return os.path.join(os.path.dirname(os.path.abspath(__file__)), suffix)

@route('/static/<filepath:path>')
def static(filepath):
	return static_file(filepath, root=relative_path(STATIC_DIR))

@route('/about')
def about():
    return template('about')

@route('/')
def index():
    return template('index')

run(host=ADDR, port=PORT)
