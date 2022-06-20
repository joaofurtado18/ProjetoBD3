#!/usr/bin/python3
from unicodedata import category
from wsgiref.handlers import CGIHandler
from flask import Flask
from flask import render_template, request
import psycopg2
import psycopg2.extras
# SGBD configs
DB_HOST = "db.tecnico.ulisboa.pt"
DB_USER = "ist199095"
DB_DATABASE = DB_USER
DB_PASSWORD = "jpyg8678"
DB_CONNECTION_STRING = "host=%s dbname=%s user=%s password=%s" % (DB_HOST, DB_DATABASE, DB_USER, DB_PASSWORD)

app = Flask(__name__)

@app.route('/')
def list_categories():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        query = "SELECT * FROM category;"
        cursor.execute(query)
        return render_template("category.html", cursor=cursor)
    
    except Exception as e:
        return str(e)  # Renders a page with the error.
    
    finally:
        cursor.close()
        dbConn.close()
        
@app.route('/remove')
def remove_categories():
    try:
        return render_template("remove.html", params=request.args)
    except Exception as e:
        return str(e)

@app.route('/update', methods=["POST"])
def remove_category():
    dbConn=None
    cursor=None
    
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        category_name = request.form["category_name"]
        query = 'DELETE FROM category WHERE category_name = %s'
        data = (category_name)
        cursor.execute(query, data)
        return query
    
    except Exception as e:
        return str(e)
    
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()


@app.route('/IVM')
def list_IVM():
    dbConn = None
    cursor = None
    
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        query = "SELECT * FROM IVM;"
        cursor.execute(query)
        return render_template("ivm.html", cursor=cursor)
    
    except Exception as e:
        return str(e)  # Renders a page with the error.
    
    finally:
        cursor.close()
        dbConn.close()
        
@app.route('/replenishment_event/<serial_number>')
def list_replenishment_event(serial_number):
    dbConn = None
    cursor = None
    
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        query = 'SELECT product_category, units \
                FROM replenishment_event \
                NATURAL JOIN product \
                GROUP BY product_category, units, serial_number \
                HAVING serial_number = %s' % (serial_number)
        cursor.execute(query)
        return render_template("replenishments.html", cursor=cursor)
    
    except Exception as e:
        return str(e)  # Renders a page with the error.
    
    finally:
        cursor.close()
        dbConn.close()
        
CGIHandler().run(app)
