#!/usr/bin/python3
from unicodedata import category
from wsgiref.handlers import CGIHandler
from flask import Flask
from flask import render_template, request, redirect, session
import psycopg2
import psycopg2.extras
# SGBD configs
DB_HOST = "db.tecnico.ulisboa.pt"
DB_USER = "ist199078"
DB_DATABASE = DB_USER
DB_PASSWORD = "root"
DB_CONNECTION_STRING = "host=%s dbname=%s user=%s password=%s" % (DB_HOST, DB_DATABASE, DB_USER, DB_PASSWORD)

app = Flask(__name__)
app.secret_key= "secret"
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
        query = 'DELETE FROM category WHERE category_name = %s'
        data = (category_name,)
        cursor.execute(query, data)
        return redirect(f'/~{DB_USER}/app.cgi/') 
    
    except Exception as e:
        return str(e)  # Renders a page with the error.
    
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()
        
@app.route('/new_category')
def new_category():
    try:
        return render_template("add_category.html", params=request.args)
    except Exception as e:
        return str(e)
@app.route('/new_subcat/<super_category_name>')
def new_subcat(super_category_name):
    try:
        session["supercat"] = super_category_name
        return render_template("add_subcat.html", super_category_name=super_category_name)
    except Exception as e:
        return str(e)
@app.route('/new_subcat/update_subcat', methods=["POST"])
def add_subcat():
    dbConn=None
    cursor=None
    
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        category_name = request.form["sub_category_name"]
        super_category_name = session["supercat"]
        query = 'BEGIN;\
                INSERT INTO category VALUES (%s);\
                INSERT INTO simple_category VALUES (%s);\
                INSERT INTO has_other VALUES (%s, %s);'
        data=(category_name, category_name, super_category_name, category_name)
        cursor.execute(query, data)
        return redirect(f'/~{DB_USER}/app.cgi/')
    
    except Exception as e:
        return str(e) 
    
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()

@app.route('/update_category', methods=["POST"])
def add_category():
    dbConn=None
    cursor=None
    
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        category_name = request.form["category_name"]
        query = 'BEGIN;\
                INSERT INTO category VALUES (%s);\
                INSERT INTO super_category VALUES (%s);'
        data=(category_name, category_name)
        cursor.execute(query, data)
        return redirect(f'/~{DB_USER}/app.cgi/')
    
    except Exception as e:
        return str(e)
    
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()
@app.route('/teste')
def test():
    return render_template('menu.html')

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
                HAVING serial_number = %s'
        data = (serial_number,)
        cursor.execute(query, data)
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
        
@app.route('/remove_retailer/<TIN>')
def remove_retailer(TIN):
    dbConn = None
    cursor = None
    
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        query = 'DELETE FROM retailer WHERE TIN = \'%s\'' % (TIN)
        cursor.execute(query)
        return redirect(f'/~{DB_USER}/app.cgi/retailer')
    
    except Exception as e:
        return str(e)  # Renders a page with the error.
    
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()
        
@app.route('/new_retailer')
def new_retailer():
    try:
        return render_template("add_retailer.html", params=request.args)
    except Exception as e:
        return str(e)
        
@app.route('/update_retailer', methods=["POST"])
def add_retailer():
    dbConn=None
    cursor=None
    
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        tin = request.form["TIN"]
        retailer_name = request.form["retailer_name"]
        query = 'INSERT INTO retailer VALUES (%s, %s)'
        data=(tin, retailer_name)
        cursor.execute(query, data)
        return redirect(f'/~{DB_USER}/app.cgi/retailer')
    
    except Exception as e:
        return str(e)
    
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()


@app.route('/list_subcategories/<category_name>')
def list_subcat(category_name):
    dbConn = None
    cursor = None
    
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        query = 'WITH RECURSIVE subcat AS ( \
                SELECT has_other_category, has_other_super_category \
                        FROM has_other WHERE has_other_super_category = \'%s\' \
                UNION ALL \
                    SELECT h.has_other_category, h.has_other_super_category  \
                    FROM has_other h, subcat s \
                        WHERE h.has_other_super_category = s.has_other_category	 \
            ) SELECT has_other_category FROM subcat;' % (category_name) 
        cursor.execute(query)
        return render_template("subcat.html", cursor=cursor)
    
    except Exception as e:
        return str(e)
    
    finally:
        cursor.close()
        dbConn.close()
        
CGIHandler().run(app)

