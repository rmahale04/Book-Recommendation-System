from flask import Flask, render_template, request, redirect, url_for, flash, session
import mysql.connector
from mysql.connector import Error
from werkzeug.security import generate_password_hash, check_password_hash
import re

app = Flask(__name__)
app.secret_key = "NextRead_2025_LoginKey!"

# db info
db_config = {
    "host": "localhost",
    "port": 3306,
    "user": "root",
    "password": "Netra@432",
    "database": "books_db"
}

# connect with db_confib dict
def get_db_connection():
    return mysql.connector.connect(**db_config)

# pwd validation
def validate_password(password):
    if len(password) < 8 or len(password) > 16:
        return "Password must be between 8 and 16 characters."
    if not re.search(r"[A-Z]", password):
        return "Password must contain at least one uppercase letter."
    if not re.search(r"[a-z]", password):
        return "Password must contain at least one lowercase letter."
    if not re.search(r"[0-9]", password):
        return "Password must contain at least one number."
    if not re.search(r"[!@#$%^&*()-_=+/',.?\":{}|<>]", password):
        return "Password must contain at least one special character."
    return None

# validation
def validate_registration(form_data):
    errors = {}

    if not form_data.get("first_name"):
        errors["first_name"] = "First name is required."
    if not form_data.get("last_name"):
        errors["last_name"] = "Last name is required."
    if not form_data.get("username"):
        errors["username"] = "Username is required."
    if not form_data.get("email"):
        errors["email"] = "Email is required."
    # if not form_data.get("password"):
    #     errors["password"] = "Password is required."
    # elif len(form_data["password"]) < 8:
    #     errors["password"] = "Password must be at least 8 characters."
    # if form_data.get("password") != form_data.get("confirm_password"):
    #     errors["confirm_password"] = "Passwords do not match."

    password_error = validate_password(form_data.get("password", ""))
    if password_error:
        errors["password"] = password_error
    elif form_data.get("password") != form_data.get("confirm_password"):
        errors["confirm_password"] = "Passwords do not match."

    return errors

# route
@app.route("/")
def index():
    return redirect(url_for("login"))

@app.route("/register", methods=["GET", "POST"])
def register():
    form_data = {}
    errors = {}

    if request.method == "POST":
        form_data = {
            "first_name": request.form.get("first_name", "").strip(),
            "last_name": request.form.get("last_name", "").strip(),
            "username": request.form.get("username", "").strip(),
            "email": request.form.get("email", "").strip(),
            "password": request.form.get("password", "").strip(),
            "confirm_password": request.form.get("confirm_password", "").strip()
        }

        errors = validate_registration(form_data)
        if errors:
            return render_template("register.html", form_data=form_data, errors=errors)

        try:
            conn = get_db_connection()
            cursor = conn.cursor(dictionary=True)

            # email already exist or not
            cursor.execute("SELECT * FROM users WHERE email=%s", (form_data["email"],))
            if cursor.fetchone():
                errors["email"] = "Email already exists."
                conn.close()
                return render_template("register.html", form_data=form_data, errors=errors)
            
            # username already exist or not
            cursor.execute("SELECT * FROM users WHERE username=%s", (form_data["username"],))
            if cursor.fetchone():
                errors["username"] = "Username already exists."
                conn.close()
                return render_template("register.html", form_data=form_data, errors=errors)

            # pwd hash
            hashed_pw = generate_password_hash(form_data["password"])

            cursor.execute(
                "INSERT INTO users (first_name, last_name, username, email, password_hash) VALUES (%s, %s, %s, %s, %s)",
                (form_data["first_name"], form_data["last_name"], form_data["username"], form_data["email"], hashed_pw)
            )
            conn.commit()
            conn.close()

            flash("Account created successfully! Please login.")
            return redirect(url_for("login"))
        
        except Error as e:
            errors["database"] = str(e)
            # flash("Error: " + str(e))
            # return redirect(url_for("register"))
            return render_template("register.html", form_data=form_data, errors=errors)

    return render_template("register.html", form_data=form_data, errors=errors)

@app.route("/login", methods=["GET", "POST"])
def login():
    form_data = {}
    errors = {}

    if request.method == "POST":
        # form_data = {
        #     "email": request.form.get("email", "").strip(),
        #     "password": request.form.get("password", "").strip()
        # }
        identifier = request.form.get("email", "").strip()  # can be email or username
        password = request.form.get("password", "").strip()

        # if not form_data["email"]:
        #     errors["email"] = "Email is required."
        # if not form_data["password"]:
        #     errors["password"] = "Password is required."
        if not identifier:
            errors["email"] = "Email/Username is required."
        if not password:
            errors["password"] = "Password is required."

        if errors:
            return render_template("login.html", form_data=form_data, errors=errors)

        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)

        cursor.execute("SELECT * FROM users WHERE email=%s OR username=%s", (identifier, identifier))
        user = cursor.fetchone()
        conn.close()

        if user:
            if check_password_hash(user["password_hash"], password):
                session["user_id"] = user["user_id"]
                session["username"] = user["username"]
                flash("Login successful!")
                return redirect(url_for("home"))
            else:
                errors["password"] = "Incorrect password."
        else:
            errors["email"] = "No account found with that email/username."
    
    return render_template("login.html", form_data=form_data, errors=errors)

@app.route("/home")
def home():
    if "user_id" in session:
        return render_template("home.html", user=session.get("username"))
    else:
        flash("Please log in first.")
        return redirect(url_for("login"))

@app.route("/logout")
def logout():
    session.pop("user_id", None)
    session.pop("username", None)
    flash("You have been logged out.")
    return redirect(url_for("login"))


@app.route("/profile")
def profile():
    if "user_id" not in session:
        flash("Please log in first.")
        return redirect(url_for("login"))

    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT first_name, last_name, username, email FROM users WHERE user_id=%s", (session["user_id"],))
        user = cursor.fetchone()
        conn.close()

        if not user:
            flash("User not found.")
            return redirect(url_for("home"))

        return render_template("profile.html", user=user)

    except Error as e:
        flash("Database error: " + str(e))
        return redirect(url_for("home"))


if __name__ == "__main__":
    app.run(debug=True)

