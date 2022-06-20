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
        
@app.route('/remove_category/<category_name>')
def remove_category(category_name):
    dbConn = None
    cursor = None
    
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        query = 'DELETE FROM category WHERE category_name = %s' % (category_name)
        cursor.execute(query)
        return render_template("category.html", cursor=cursor)
    
    except Exception as e:
        return str(e)  # Renders a page with the error.
    
    finally:
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
        
@app.route('/retailer')
def list_retailer():
    dbConn = None
    cursor = None
    
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        query = "SELECT * FROM retailer;"
        cursor.execute(query)
        return render_template("retailer.html", cursor=cursor)
    
    except Exception as e:
        return str(e)  # Renders a page with the error.
    
    finally:
        cursor.close()
        dbConn.close()
        
# @app.route('/remove_retailer/<TIN>')
# def remove_retailer(TIN):
#     dbConn = None
#     cursor = None
    
#     try:
#         dbConn = psycopg2.connect(DB_CONNECTION_STRING)
#         cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
#         query = 'DELETE FROM retailer WHERE TIN = %s' % (TIN)
#         cursor.execute(query)
#         return render_template("category.html", cursor=cursor)
    
#     except Exception as e:
#         return str(e)  # Renders a page with the error.
    
#     finally:
#         cursor.close()
#         dbConn.close()
        
CGIHandler().run(app)
