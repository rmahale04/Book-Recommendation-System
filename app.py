from flask import Flask, render_template, request, redirect, url_for, flash, session
import mysql.connector
from mysql.connector import Error
from werkzeug.security import generate_password_hash, check_password_hash

app = Flask(__name__)
app.secret_key = "NextRead_2025_LoginKey!"

db_config = {
    "host": "localhost",
    "port": 3306,
    "user": "root",
    "password": "gj@riya01",
    "database": "books_db"
}

@app.route("/")
def index():
    return render_template("login.html")

@app.route("/register", methods=["POST"])
def register():
    return render_template('register.html')

@app.route("/login", methods=["POST"])
def login():
    if request.method == "POST":
        email = request.form["email"]   
        password = request.form["password"]

        if email == "test@nextread.com" and password == "1234":
            return redirect(url_for("home"))
        else:
            flash("Invalid email or password. Please try again.")
            return redirect(url_for("index"))
    
    return render_template("login.html")

@app.route("/home")
def home():
    return render_template("home.html")

if __name__ == "__main__":
    app.run(debug=True)