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


# Registration

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
            user_id = cursor.lastrowid
            conn.close()

            session["user_id"] = user_id
            session["username"] = form_data["username"]
            flash("Account created successfully! Now choose your interests.")
            return redirect(url_for("select_interests"))

        
        except Error as e:
            errors["database"] = str(e)
            # flash("Error: " + str(e))
            # return redirect(url_for("register"))
            return render_template("register.html", form_data=form_data, errors=errors)

    return render_template("register.html", form_data=form_data, errors=errors)


# interests

@app.route("/interests", methods=["GET", "POST"])
def select_interests():
    if "user_id" not in session:
        flash("Please log in first.")
        return redirect(url_for("login"))

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT genre_id, genre_name FROM genres")
    genres = cursor.fetchall()

    if request.method == "POST":
        selected_genres = request.form.getlist("interests")
        if len(selected_genres) < 5:
            flash("Please select at least 5 genres.")
            return render_template("interest.html", genres=genres)

        # Save selected interests in user_genres table
        for gid in selected_genres:
            cursor.execute(
                "INSERT IGNORE INTO user_genres (user_id, genre_id) VALUES (%s, %s)",
                (session["user_id"], gid)
            )

        conn.commit()
        conn.close()

        flash("Interests saved successfully!")
        return redirect(url_for("home"))

    conn.close()
    return render_template("interest.html", genres=genres)


#login

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
                session["role"] = user["role"]

                flash("Login successful!")

                if user["role"] == "Admin":
                    return redirect(url_for("admin_dashboard"))
                else:
                    return redirect(url_for("home"))
            
            else:
                errors["password"] = "Incorrect password."
        else:
            errors["email"] = "No account found with that email/username."
    
    return render_template("login.html", form_data=form_data, errors=errors)


# admin dashboard

@app.route("/admin_dashboard")
def admin_dashboard():
    if session.get("role", "").lower() != "admin":
        flash("Access denied. Admins only.")
        return redirect(url_for("home"))

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    # Fetch counts
    cursor.execute("SELECT COUNT(*) AS total_books FROM books")
    total_books = cursor.fetchone()["total_books"]

    cursor.execute("SELECT COUNT(*) AS total_authors FROM authors")
    total_authors = cursor.fetchone()["total_authors"]

    cursor.execute("SELECT COUNT(*) AS total_users FROM users")
    total_users = cursor.fetchone()["total_users"]

    cursor.execute("SELECT COUNT(*) AS total_genres FROM genres")
    total_genres = cursor.fetchone()["total_genres"]

    # Fetch details for each tab
    cursor.execute("""
        SELECT b.book_id, b.title, a.name AS author, b.published_year, b.language
        FROM books b
        LEFT JOIN authors a ON b.author_id = a.author_id
    """)
    books = cursor.fetchall()

    cursor.execute("SELECT * FROM authors")
    authors = cursor.fetchall()

    cursor.execute("SELECT * FROM users")
    users = cursor.fetchall()

    cursor.execute("SELECT * FROM genres")
    genres = cursor.fetchall()

    cursor.execute("SELECT * FROM series")
    series = cursor.fetchall()

    cursor.close()
    conn.close()

    return render_template(
        "admin_dashboard.html",
        total_books=total_books,
        total_authors=total_authors,
        total_users=total_users,
        total_genres=total_genres,
        books=books,
        authors=authors,
        users=users,
        genres=genres,
        series=series
    )


# home page


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
    session.pop("role", None)
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


# view a page where complete info of a book is displayed    

# book detail
@app.route("/book/<int:book_id>")
def book_details(book_id):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT b.book_id, b.title, a.name AS author, s.name AS series,
               b.published_year, b.cover_image_url, b.language, b.description,
               GROUP_CONCAT(DISTINCT g.genre_name SEPARATOR ', ') AS genres
        FROM books b
        LEFT JOIN authors a ON b.author_id = a.author_id
        LEFT JOIN series s ON b.series_id = s.series_id
        LEFT JOIN book_genres bg ON b.book_id = bg.book_id
        LEFT JOIN genres g ON bg.genre_id = g.genre_id
        WHERE b.book_id = %s
        GROUP BY b.book_id
    """, (book_id,))

    book = cursor.fetchone()
    cursor.close()
    conn.close()

    if not book:
        flash("Book not found.")
        return redirect(url_for("view_books"))

    return render_template("book_details.html", book=book)



# @app.route("/all-books")

#search query

@app.route("/books")
def view_books():
    search_query = request.args.get("q", "").strip()
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    if "user_id" in session and search_query:
        cursor.execute(
            "INSERT INTO user_search_history (user_id, search_query) VALUES (%s, %s)",
            (session["user_id"], search_query)
        )
        conn.commit()

    base_query = """
        SELECT 
            b.book_id, b.title, a.name AS author, s.name AS series,
            b.published_year, b.cover_image_url, b.language, b.description,
            GROUP_CONCAT(DISTINCT g.genre_name SEPARATOR ', ') AS genres
        FROM books b
        LEFT JOIN authors a ON b.author_id = a.author_id
        LEFT JOIN series s ON b.series_id = s.series_id
        LEFT JOIN book_genres bg ON b.book_id = bg.book_id
        LEFT JOIN genres g ON bg.genre_id = g.genre_id
    """

    params = ()
    if search_query:
        # Use WHERE before GROUP BY, not HAVING
        base_query += """
            WHERE 
                b.title LIKE %s OR 
                a.name LIKE %s OR 
                s.name LIKE %s OR 
                b.language LIKE %s OR 
                b.description LIKE %s
        """
        like_pattern = f"%{search_query}%"
        params = (like_pattern, like_pattern, like_pattern, like_pattern, like_pattern)

    # Only one GROUP BY at the end
    base_query += """
        group by b.book_id
        order by b.title
    """

    cursor.execute(base_query, params)
    books = cursor.fetchall()

    cursor.close()
    conn.close()

    return render_template("view_books.html", books=books, search_query=search_query)

# @app.route("/all-books")
# def view_all_books():

#     conn = get_db_connection()
#     cursor = conn.cursor(dictionary=True)

#     cursor.execute("""
#         SELECT b.title, a.name AS author, s.name AS series,
#                b.published_year, b.cover_image_url
#         FROM books b
#         LEFT JOIN authors a ON b.author_id = a.author_id
#         LEFT JOIN series s ON b.series_id = s.series_id
#     """)
#     books = cursor.fetchall()
#     cursor.close()
#     conn.close()

#     return render_template("view_all_books.html", books=books, active_page="books")

# recommendation

@app.route("/recommendations")
def recommendations():
    if "user_id" not in session:
        flash("Please log in first.")
        return redirect(url_for("login"))

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    # --- 1️ Get user's selected genres ---
    cursor.execute("""
        SELECT g.genre_name
        FROM user_genres ug
        JOIN genres g ON ug.genre_id = g.genre_id
        WHERE ug.user_id = %s
    """, (session["user_id"],))
    user_genres = [row["genre_name"] for row in cursor.fetchall()]

    # --- 2️ Get user's recent searches ---
    cursor.execute("""
        SELECT search_query FROM user_search_history
        WHERE user_id=%s
        ORDER BY search_date DESC
        LIMIT 5
    """, (session["user_id"],))
    searches = [row["search_query"] for row in cursor.fetchall()]

    # --- 3️ Recommend based on genres ---
    genre_books = []
    if user_genres:
        placeholders = ",".join(["%s"] * len(user_genres))
        cursor.execute(f"""
            SELECT DISTINCT b.book_id, b.title, a.name AS author, b.cover_image_url, g.genre_name
            FROM books b
            JOIN book_genres bg ON b.book_id = bg.book_id
            JOIN genres g ON bg.genre_id = g.genre_id
            LEFT JOIN authors a ON b.author_id = a.author_id
            WHERE g.genre_name IN ({placeholders})
            LIMIT 10
        """, tuple(user_genres))
        genre_books = cursor.fetchall()

    # --- 4️ Recommend based on recent searches ---
    search_books = []
    if searches:
        query_conditions = " OR ".join(["b.title LIKE %s OR g.genre_name LIKE %s"] * len(searches))
        params = []
        for s in searches:
            like_s = f"%{s}%"
            params.extend([like_s, like_s])
        cursor.execute(f"""
            SELECT DISTINCT b.book_id, b.title, a.name AS author, b.cover_image_url
            FROM books b
            LEFT JOIN authors a ON b.author_id = a.author_id
            LEFT JOIN book_genres bg ON b.book_id = bg.book_id
            LEFT JOIN genres g ON bg.genre_id = g.genre_id
            WHERE {query_conditions}
            LIMIT 10
        """, params)
        search_books = cursor.fetchall()

    cursor.close()
    conn.close()

    return render_template(
        "recommendations.html",
        search_books=search_books,
        genre_books=genre_books,
        active_page="recommendations"
    )


# add author

@app.route("/add_author", methods=["GET", "POST"])
def add_author():
    if "user_id" not in session:
        flash("Please log in first.")
        return redirect(url_for("login"))

    errors = {}
    form_data = {}

    if request.method == "POST":
        form_data = {
            "name": request.form.get("name", "").strip(),
            "biography": request.form.get("biography", "").strip(),
            "date_of_birth": request.form.get("date_of_birth", "").strip(),
            "date_of_death": request.form.get("date_of_death", "").strip(),
        }

        if not form_data["name"]:
            errors["name"] = "Author name is required."

        if not errors:
            try:
                conn = get_db_connection()
                cursor = conn.cursor()

                cursor.execute("""
                    INSERT INTO authors (name, biography, date_of_birth, date_of_death)
                    VALUES (%s, %s, %s, %s)
                """, (
                    form_data["name"],
                    form_data["biography"] or None,
                    form_data["date_of_birth"] or None,
                    form_data["date_of_death"] or None
                ))

                conn.commit()
                conn.close()
                flash("Author added successfully!")
                return redirect(url_for("view_books"))  # redirect somewhere useful

            except Error as e:
                errors["database"] = str(e)

    return render_template("add_author.html", form_data=form_data, errors=errors)



# view authors

@app.route("/authors")
def view_authors():
    if "user_id" not in session:
        flash("Please log in first.")
        return redirect(url_for("login"))

    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)

        cursor.execute("""
            SELECT author_id, name, biography, date_of_birth, date_of_death
            FROM authors
            ORDER BY name
        """)
        authors = cursor.fetchall()

        cursor.close()
        conn.close()

        return render_template("view_authors.html", authors=authors)

    except Error as e:
        flash("Database error: " + str(e))
        return redirect(url_for("home"))


if __name__ == "__main__":
    app.run(debug=True)
