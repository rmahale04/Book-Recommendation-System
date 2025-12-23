# app.py
# MERGED & CLEANED version created for the user.
# Original uploaded file path (for reference): /mnt/data/app.py

from flask import Flask, render_template, request, redirect, url_for, flash, session, abort
import mysql.connector
from mysql.connector import Error
from werkzeug.security import generate_password_hash, check_password_hash
import re

app = Flask(__name__)
app.secret_key = "NextRead_2025_LoginKey!"

# =========================
# Database configuration
# =========================
db_config = {
    "host": "localhost",
    "port": 3306,
    "user": "root",
    "password": "Netra@432",
    "database": "books_db2"
}

def get_db_connection():
    return mysql.connector.connect(**db_config)


# =========================
# Utilities & validators
# =========================
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

    password_error = validate_password(form_data.get("password", ""))
    if password_error:
        errors["password"] = password_error
    elif form_data.get("password") != form_data.get("confirm_password"):
        errors["confirm_password"] = "Passwords do not match."

    return errors


# =========================
# ROUTES
# =========================

@app.route("/")
def index():
    # default to login
    return redirect(url_for("login"))


# -------------------------
# Registration
# -------------------------
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

            cursor.execute("""
                INSERT INTO shelves (user_id, name, is_default) VALUES
                (%s, 'Currently Reading', TRUE),
                (%s, 'Read', TRUE),
                (%s, 'Want To Read', TRUE)
            """, (user_id, user_id, user_id))
            conn.commit()

            conn.close()

            session["user_id"] = user_id
            session["username"] = form_data["username"]
            flash("Account created successfully! Now choose your interests.")
            return redirect(url_for("select_interests"))

        except Error as e:
            errors["database"] = str(e)
            return render_template("register.html", form_data=form_data, errors=errors)

    return render_template("register.html", form_data=form_data, errors=errors)


# -------------------------
# Login
# -------------------------
@app.route("/login", methods=["GET", "POST"])
def login():
    form_data = {}
    errors = {}

    if request.method == "POST":
        identifier = request.form.get("email", "").strip()  # can be email or username
        password = request.form.get("password", "").strip()

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
                session["role"] = user.get("role", None)

                flash("Login successful!")

                if user.get("role", "").lower() == "admin":
                    return redirect(url_for("admin_dashboard"))
                else:
                    return redirect(url_for("home"))
            
            else:
                errors["password"] = "Incorrect password."
        else:
            errors["email"] = "No account found with that email/username."
    
    return render_template("login.html", form_data=form_data, errors=errors)


# -------------------------
# Interests after registration
# -------------------------
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


# -------------------------
# Admin dashboard (keeps original logic)
# -------------------------
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


# -------------------------
# Home
# -------------------------
@app.route("/home")
def home():
    if "user_id" in session:
        return render_template("home.html", user=session.get("username"))
    else:
        flash("Please log in first.")
        return redirect(url_for("login"))


# -------------------------
# Books listing & search
# -------------------------
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

    base_query += """
        GROUP BY b.book_id
        ORDER BY b.title
    """

    cursor.execute(base_query, params)
    books = cursor.fetchall()

    cursor.close()
    conn.close()

    return render_template("view_books.html", books=books, search_query=search_query)


# -------------------------
# Book detail
# -------------------------
@app.route("/book/<int:book_id>")
def book_details(book_id):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    # --- Book details ---
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

    if not book:
        conn.close()
        flash("Book not found.", "error")
        return redirect(url_for("view_books"))

    # --- Shelves ---
    shelves = []
    if "user_id" in session:
        cursor.execute("""
            SELECT shelf_id, name FROM shelves 
            WHERE user_id = %s 
            ORDER BY is_default DESC, name
        """, (session["user_id"],))
        shelves = cursor.fetchall()

    # --- Average rating & count ---
    cursor.execute("""
        SELECT AVG(ratings) AS avg_rating, COUNT(*) AS total_reviews
        FROM reviews 
        WHERE book_id = %s AND ratings IS NOT NULL
    """, (book_id,))
    rating_info = cursor.fetchone()
    avg_rating = round(rating_info['avg_rating'], 1) if rating_info['avg_rating'] else 0.0
    total_reviews = rating_info['total_reviews']

    # --- All reviews ---
    cursor.execute("""
        SELECT r.review_id, r.ratings, r.review_text, r.review_date, u.username
        FROM reviews r
        JOIN users u ON r.user_id = u.user_id
        WHERE r.book_id = %s
        ORDER BY r.review_date DESC
    """, (book_id,))
    reviews = cursor.fetchall()

    # --- Current user's review (for pre-filling form) ---
    user_review = None
    if "user_id" in session:
        cursor.execute("""
            SELECT ratings, review_text 
            FROM reviews 
            WHERE user_id = %s AND book_id = %s
        """, (session["user_id"], book_id))
        user_review = cursor.fetchone()

    book["cover_image_url"] = (book["cover_image_url"] or "").strip() or None

    cursor.close()
    conn.close()

    return render_template("book_details.html",
                           book=book,
                           shelves=shelves,
                           avg_rating=avg_rating,
                           total_reviews=total_reviews,
                           reviews=reviews,
                           user_review=user_review)


@app.route("/book/<int:book_id>/review", methods=["POST"])
def add_review(book_id):
    if "user_id" not in session:
        flash("Please log in to review.", "error")
        return redirect(url_for("login"))

    user_id = session["user_id"]
    rating = request.form.get("rating")
    review_text = request.form.get("review_text", "").strip()

    if not rating or not rating.isdigit() or int(rating) not in range(1, 6):
        flash("Please select a valid rating (1–5 stars).", "error")
        return redirect(url_for("book_details", book_id=book_id))

    rating = int(rating)

    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        # CORRECT COLUMN NAME: ratings (with s)
        cursor.execute("""
            INSERT INTO reviews (user_id, book_id, ratings, review_text)
            VALUES (%s, %s, %s, %s)
            ON DUPLICATE KEY UPDATE 
                ratings = VALUES(ratings),
                review_text = VALUES(review_text),
                review_date = CURRENT_TIMESTAMP
        """, (user_id, book_id, rating, review_text or None))

        conn.commit()
        flash("Thank you! Your review has been saved.", "success")

    except Exception as e:
        conn.rollback()
        # VERY IMPORTANT: Log the actual error
        print("Review save error:", str(e))  # This will appear in your terminal/console
        flash(f"Database error: {str(e)}", "error")

    finally:
        cursor.close()
        conn.close()

    return redirect(url_for("book_details", book_id=book_id))


@app.route("/add_to_shelf/<int:book_id>", methods=["POST"])
def add_to_shelf(book_id):
    if "user_id" not in session:
        flash("Please log in first.")
        return redirect(url_for("login"))

    shelf_id = request.form.get("shelf_id")
    new_shelf_name = request.form.get("new_shelf_name", "").strip()

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    # If user typed “Create New Shelf”
    if new_shelf_name:
        cursor.execute(
            "INSERT INTO shelves (user_id, name, is_default) VALUES (%s, %s, FALSE)",
            (session["user_id"], new_shelf_name)
        )
        conn.commit()
        shelf_id = cursor.lastrowid

    # Insert book into shelf
    cursor.execute("""
        INSERT IGNORE INTO user_shelf_books (shelf_id, book_id)
        VALUES (%s, %s)
    """, (shelf_id, book_id))
    conn.commit()

    cursor.close()
    conn.close()
    flash("Book added to your shelf!")
    return redirect(url_for("book_details", book_id=book_id))

# -------------------------
# Followers / Following management
# (original logic preserved; duplicates commented later)
# -------------------------
@app.route('/followers')
def followers_page():
    current_user = session.get('user_id')
    if not current_user:
        flash("Please log in first!")
        return redirect(url_for('login'))

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT f.follow_id, u.user_id, u.username, f.status
        FROM follows f
        JOIN users u ON f.follower_id = u.user_id
        WHERE f.following_id = %s
    """, (current_user,))

    followers = cursor.fetchall()

    cursor.close()
    conn.close()

    return render_template('followers.html', followers=followers)


@app.route('/following')
def following_page():
    current_user = session.get('user_id')
    if not current_user:
        flash("Please log in first!")
        return redirect(url_for('login'))

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT u.user_id, u.username, f.status
        FROM follows f
        JOIN users u ON f.following_id = u.user_id
        WHERE f.follower_id = %s AND f.status='accepted'
    """, (current_user,))
    following = cursor.fetchall()

    cursor.close()
    conn.close()

    return render_template('following.html', following=following)


@app.route('/follow/<int:user_id>')
def follow_user(user_id):
    current_user = session.get('user_id')
    if not current_user:
        flash("Please log in first!")
        return redirect(url_for('login'))
    
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("SELECT * FROM follows WHERE follower_id=%s AND following_id=%s", (current_user, user_id))
    existing = cursor.fetchone()

    if existing:
        flash("Request already sent or you already follow this user.")
        conn.close()
        return redirect(url_for('users_list'))

    cursor.execute(
        "INSERT INTO follows (follower_id, following_id, status) VALUES (%s, %s, 'pending')",
        (current_user, user_id)
    )

    conn.commit()
    conn.close()
    flash("Follow request sent!")
    return redirect(url_for('users_list'))


@app.route('/accept_follow/<int:follow_id>')
def accept_follow(follow_id):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("UPDATE follows SET status='accepted' WHERE follow_id=%s", (follow_id,))
    conn.commit()
    cursor.close()
    conn.close()
    flash("Follow request accepted!")
    return redirect(url_for('followers_page'))


@app.route('/reject_follow/<int:follow_id>')
def reject_follow(follow_id):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("UPDATE follows SET status='rejected' WHERE follow_id=%s", (follow_id,))
    conn.commit()
    cursor.close()
    conn.close()
    flash("Follow request rejected.")
    return redirect(url_for('followers_page'))


@app.route('/unfollow/<int:user_id>')
def unfollow_user(user_id):
    current_user = session.get('user_id')
    if not current_user:
        flash("Please log in first!")
        return redirect(url_for('login'))
    
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("DELETE FROM follows WHERE follower_id=%s AND following_id=%s", (current_user, user_id))
    conn.commit()
    cursor.close()
    conn.close()
    flash("You unfollowed this user.")
    return redirect(url_for('following_page'))


@app.route('/follow_back/<int:user_id>')
def follow_back(user_id):
    current_user = session.get('user_id')
    if not current_user:
        flash("Please log in first!")
        return redirect(url_for('login'))

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("INSERT INTO follows (follower_id, following_id, status) VALUES (%s, %s, 'accepted')",
                   (current_user, user_id))
    conn.commit()
    cursor.close()
    conn.close()
    flash("Followed back!")
    return redirect(url_for('followers_page'))


# -------------------------
# Profile routes (Option A)
# - /profile -> redirect to user profile (self)
# - /profile/<username> -> view any user's profile
# -------------------------
# @app.route("/profile")
# def profile_root():
#     if "user_id" not in session:
#         flash("Please log in first.")
#         return redirect(url_for("login"))
#     # redirect to user's username-specific profile
#     return redirect(url_for("profile_by_username", username=session["username"]))


@app.route('/profile/<username>')
def profile_by_username(username):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    # Fetch user
    cursor.execute("""
        SELECT user_id, first_name, last_name, username, email, join_date, 
               bio, about_me, profile_image_url 
        FROM users WHERE username = %s
    """, (username,))
    user = cursor.fetchone()
    if not user:
        conn.close()
        flash("User not found.", "error")
        return redirect(url_for("home"))

    user_id = user["user_id"]

    # Follower / Following counts
    cursor.execute("SELECT COUNT(*) AS cnt FROM follows WHERE following_id = %s", (user_id,))
    followers_count = cursor.fetchone()["cnt"]
    cursor.execute("SELECT COUNT(*) AS cnt FROM follows WHERE follower_id = %s", (user_id,))
    following_count = cursor.fetchone()["cnt"]

    # Friends (accepted requests)
    cursor.execute("""
        SELECT DISTINCT u.user_id, u.username, u.first_name, u.last_name, u.profile_image_url
        FROM friend_requests fr
        JOIN users u ON (fr.requester_id = u.user_id AND fr.requestee_id = %s)
                     OR (fr.requestee_id = u.user_id AND fr.requester_id = %s)
        WHERE fr.status = 'accepted'
    """, (user_id, user_id))
    friends = cursor.fetchall()

    # === USER'S REVIEWS + RATINGS (from `reviews` table) ===
    cursor.execute("""
        SELECT 
            r.ratings,
            r.review_text,
            r.review_date,
            b.book_id,
            b.title,
            b.cover_image_url,
            a.name AS author
        FROM reviews r
        JOIN books b ON r.book_id = b.book_id
        LEFT JOIN authors a ON b.author_id = a.author_id
        WHERE r.user_id = %s
        ORDER BY r.review_date DESC
    """, (user_id,))
    reviews = cursor.fetchall()  # Now contains full review + rating

    # Followers list (for popup)
    cursor.execute("""
        SELECT u.user_id, u.username, u.first_name, u.last_name, u.profile_image_url
        FROM follows f
        JOIN users u ON f.follower_id = u.user_id
        WHERE f.following_id = %s
    """, (user_id,))
    followers = cursor.fetchall()

    # Following list
    cursor.execute("""
        SELECT u.user_id, u.username, u.first_name, u.last_name, u.profile_image_url
        FROM follows f
        JOIN users u ON f.following_id = u.user_id
        WHERE f.follower_id = %s
    """, (user_id,))
    following = cursor.fetchall()

    # User's library (recent 12 books)
    # cursor.execute("""
    #     SELECT DISTINCT b.book_id, b.title, b.cover_image_url
    #     FROM user_shelf_books usb
    #     JOIN shelves s ON usb.shelf_id = s.shelf_id
    #     JOIN books b ON usb.book_id = b.book_id
    #     WHERE s.user_id = %s
    #     LIMIT 12
    # """, (user_id,))
    # books = cursor.fetchall()

    # ===== USER'S SHELVES WITH BOOKS =====
    cursor.execute("""
        SELECT shelf_id, `name` 
        FROM shelves
        WHERE user_id = %s
        ORDER BY is_default DESC, `name`
    """, (user_id,))
    shelves = cursor.fetchall()

    for shelf in shelves:
        cursor.execute("""
            SELECT 
                b.book_id, b.title, b.cover_image_url
            FROM user_shelf_books usb
            JOIN books b ON usb.book_id = b.book_id
            WHERE usb.shelf_id = %s
            ORDER BY usb.added_date DESC
        """, (shelf["shelf_id"],))
        shelf["books"] = cursor.fetchall()


    cursor.close()
    conn.close()

    return render_template("profile.html",
                           user=user,
                           followers=followers,
                           following=following,
                           followers_count=followers_count,
                           following_count=following_count,
                           friends=friends,
                           reviews=reviews,   # ← Now passing full reviews
                           shelves=shelves)
    
@app.route("/remove_from_shelf/<int:shelf_id>/<int:book_id>", methods=["POST"])
def remove_from_shelf(shelf_id, book_id):
    if "user_id" not in session:
        flash("Please log in.", "error")
        return redirect(url_for("login"))

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    # verify this shelf belongs to current user
    cursor.execute("SELECT user_id FROM shelves WHERE shelf_id=%s", (shelf_id,))
    shelf = cursor.fetchone()

    if not shelf or shelf["user_id"] != session["user_id"]:
        flash("You cannot modify this shelf.", "error")
        cursor.close()
        conn.close()
        return redirect(url_for("profile_root"))

    cursor.execute("""
        DELETE FROM user_shelf_books
        WHERE shelf_id=%s AND book_id=%s
    """, (shelf_id, book_id))
    conn.commit()

    cursor.close()
    conn.close()

    flash("Book removed from shelf.", "success")
    return redirect(url_for("profile_root"))

    
# -------------------------
# Library route (username based)
# -------------------------
@app.route('/library/<username>')
def library_by_username(username):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("SELECT user_id, first_name, last_name, username FROM users WHERE username=%s", (username,))
    user = cursor.fetchone()

    if not user:
        cursor.close()
        conn.close()
        flash("User not found.")
        return redirect(url_for("home"))

    cursor.execute("""
        SELECT distinct b.book_id, b.title, b.cover_image_url
        FROM user_shelf_books usb
        join shelves s on usb.shelf_id = s.shelf_id
        JOIN books b ON usb.book_id = b.book_id
        WHERE s.user_id = %s
    """, (user["user_id"],))
    books = cursor.fetchall()

    cursor.close()
    conn.close()
    return render_template("library.html", user=user, books=books)

@app.route("/library/<int:user_id>")
def user_library(user_id):
    """Display user's complete library organized by shelves"""
    
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    # Get user information
    cursor.execute("""
        SELECT user_id, username, first_name, last_name, profile_image_url
        FROM users
        WHERE user_id = %s
    """, (user_id,))
    user = cursor.fetchone()
    
    if not user:
        flash("User not found.", "error")
        return redirect(url_for("home"))
    
    # Get all shelves for this user
    cursor.execute("""
        SELECT shelf_id, name, is_default, created_at
        FROM shelves
        WHERE user_id = %s
        ORDER BY 
            CASE 
                WHEN name = 'Currently Reading' THEN 1
                WHEN name = 'Want To Read' THEN 2
                WHEN name = 'Read' THEN 3
                ELSE 4
            END,
            created_at ASC
    """, (user_id,))
    shelves = cursor.fetchall()
    
    # For each shelf, get its books
    total_books = 0
    for shelf in shelves:
        cursor.execute("""
            SELECT 
                b.book_id, b.title, b.cover_image_url, b.published_year,
                a.name as author_name,
                usb.added_date
            FROM user_shelf_books usb
            JOIN books b ON usb.book_id = b.book_id
            LEFT JOIN authors a ON b.author_id = a.author_id
            WHERE usb.shelf_id = %s
            ORDER BY usb.added_date DESC
        """, (shelf['shelf_id'],))
        
        shelf['books'] = cursor.fetchall()
        total_books += len(shelf['books'])
    
    cursor.close()
    conn.close()
    
    return render_template("library.html",
                         user=user,
                         shelves=shelves,
                         total_books=total_books)


# @app.route("/my_library")
# def my_library():
#     """Redirect to current user's library"""
#     if "user_id" not in session:
#         flash("Please log in to view your library.", "error")
#         return redirect(url_for("login"))
    
#     return redirect(url_for("user_library", user_id=session["user_id"]))


# @app.route("/manage_shelf/<int:shelf_id>")
# def manage_shelf(shelf_id):
#     """Page to manage a specific shelf (add/remove books)"""
#     if "user_id" not in session:
#         flash("Please log in to manage shelves.", "error")
#         return redirect(url_for("login"))
    
#     conn = get_db_connection()
#     cursor = conn.cursor(dictionary=True)
    
#     # Verify shelf belongs to current user
#     cursor.execute("""
#         SELECT shelf_id, name, is_default, user_id
#         FROM shelves
#         WHERE shelf_id = %s
#     """, (shelf_id,))
#     shelf = cursor.fetchone()
    
#     if not shelf:
#         flash("Shelf not found.", "error")
#         return redirect(url_for("my_library"))
    
#     if shelf['user_id'] != session['user_id']:
#         flash("You don't have permission to manage this shelf.", "error")
#         return redirect(url_for("my_library"))
    
#     # Get books in this shelf
#     cursor.execute("""
#         SELECT 
#             b.book_id, b.title, b.cover_image_url, b.published_year,
#             a.name as author_name,
#             usb.added_date
#         FROM user_shelf_books usb
#         JOIN books b ON usb.book_id = b.book_id
#         LEFT JOIN authors a ON b.author_id = a.author_id
#         WHERE usb.shelf_id = %s
#         ORDER BY usb.added_date DESC
#     """, (shelf_id,))
#     books = cursor.fetchall()
    
#     cursor.close()
#     conn.close()
    
#     return render_template("manage_shelf.html",
#                          shelf=shelf,
#                          books=books)


# @app.route("/remove_from_shelf/<int:shelf_id>/<int:book_id>", methods=["POST"])
# def remove_from_shelf(shelf_id, book_id):
#     """Remove a book from a shelf"""
#     if "user_id" not in session:
#         flash("Please log in to remove books from shelves.", "error")
#         return redirect(url_for("login"))
    
#     conn = get_db_connection()
#     cursor = conn.cursor(dictionary=True)
    
#     # Verify shelf belongs to current user
#     cursor.execute("""
#         SELECT user_id FROM shelves WHERE shelf_id = %s
#     """, (shelf_id,))
#     shelf = cursor.fetchone()
    
#     if not shelf or shelf['user_id'] != session['user_id']:
#         flash("You don't have permission to modify this shelf.", "error")
#         cursor.close()
#         conn.close()
#         return redirect(url_for("my_library"))
    
#     # Remove book from shelf
#     cursor.execute("""
#         DELETE FROM user_shelf_books
#         WHERE shelf_id = %s AND book_id = %s
#     """, (shelf_id, book_id))
    
#     conn.commit()
#     cursor.close()
#     conn.close()
    
#     flash("Book removed from shelf successfully.", "success")
#     return redirect(url_for("manage_shelf", shelf_id=shelf_id))


# @app.route("/add_to_shelf/<int:shelf_id>/<int:book_id>", methods=["POST"])
# def add_to_shelf(shelf_id, book_id):
#     """Add a book to a shelf"""
#     if "user_id" not in session:
#         flash("Please log in to add books to shelves.", "error")
#         return redirect(url_for("login"))
    
#     conn = get_db_connection()
#     cursor = conn.cursor(dictionary=True)
    
#     # Verify shelf belongs to current user
#     cursor.execute("""
#         SELECT user_id FROM shelves WHERE shelf_id = %s
#     """, (shelf_id,))
#     shelf = cursor.fetchone()
    
#     if not shelf or shelf['user_id'] != session['user_id']:
#         flash("You don't have permission to modify this shelf.", "error")
#         cursor.close()
#         conn.close()
#         return redirect(url_for("home"))
    
#     # Check if book already exists in shelf
#     cursor.execute("""
#         SELECT * FROM user_shelf_books
#         WHERE shelf_id = %s AND book_id = %s
#     """, (shelf_id, book_id))
    
#     if cursor.fetchone():
#         flash("This book is already in your shelf.", "info")
#     else:
#         # Add book to shelf
#         cursor.execute("""
#             INSERT INTO user_shelf_books (shelf_id, book_id, added_date)
#             VALUES (%s, %s, CURRENT_TIMESTAMP)
#         """, (shelf_id, book_id))
#         conn.commit()
#         flash("Book added to shelf successfully!", "success")
    
#     cursor.close()
#     conn.close()
    
#     return redirect(url_for("book_detail", book_id=book_id))


# -------------------------
# Edit profile (only owner can edit)
# -------------------------
@app.route('/edit_profile/<username>', methods=['GET', 'POST'])
def edit_profile(username):
    # require login
    if 'username' not in session:
        flash("Please login first.")
        return redirect(url_for('login'))

    # must be owner
    if session['username'] != username:
        flash("You are not allowed to edit another user's profile.")
        return redirect(url_for('profile_by_username', username=username))

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT user_id, first_name, last_name, username, email, bio, about_me, profile_image_url FROM users WHERE username=%s", (username,))
    user = cursor.fetchone()
    if not user:
        cursor.close()
        conn.close()
        flash("User not found.")
        return redirect(url_for('home'))

    errors = {}
    if request.method == 'POST':
        first_name = request.form.get('first_name', '').strip()
        last_name = request.form.get('last_name', '').strip()
        bio = request.form.get('bio', '').strip()
        about_me = request.form.get('about_me', '').strip()
        profile_image_url = request.form.get('profile_image_url', '').strip()

        if not first_name:
            errors['first_name'] = "First name is required."
        if not last_name:
            errors['last_name'] = "Last name is required."

        if not errors:
            try:
                cursor.execute("""
                    UPDATE users
                    SET first_name=%s, last_name=%s, bio=%s, about_me=%s, profile_image_url=%s
                    WHERE user_id=%s
                """, (first_name, last_name, bio or None, about_me or None, profile_image_url or None, user['user_id']))
                conn.commit()
                flash("Profile updated successfully.")
                cursor.close()
                conn.close()
                return redirect(url_for('profile_by_username', username=username))
            except Error as e:
                errors['database'] = str(e)

    cursor.close()
    conn.close()
    return render_template('edit_profile.html', user=user, errors=errors)


# -------------------------
# Change password (logged-in user)
# -------------------------
@app.route('/change_password', methods=['GET', 'POST'])
def change_password():
    if 'user_id' not in session:
        flash("Please log in first.")
        return redirect(url_for('login'))

    errors = {}
    if request.method == 'POST':
        current = request.form.get('current_password', '')
        newpw = request.form.get('new_password', '')
        confirm = request.form.get('confirm_password', '')

        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT password_hash FROM users WHERE user_id=%s", (session['user_id'],))
        row = cursor.fetchone()
        if not row:
            cursor.close()
            conn.close()
            flash("User record not found.")
            return redirect(url_for('login'))

        if not check_password_hash(row['password_hash'], current):
            errors['current_password'] = "Current password is incorrect."
        else:
            pw_error = validate_password(newpw)
            if pw_error:
                errors['new_password'] = pw_error
            elif newpw != confirm:
                errors['confirm_password'] = "Passwords do not match."

        if not errors:
            hashed = generate_password_hash(newpw)
            cursor.execute("UPDATE users SET password_hash=%s WHERE user_id=%s", (hashed, session['user_id']))
            conn.commit()
            cursor.close()
            conn.close()
            flash("Password changed successfully. Please log in again.")
            return redirect(url_for('logout'))

        cursor.close()
        conn.close()

    return render_template('change_password.html', errors=errors)


# -------------------------
# Forgot password (mock)
# -------------------------
@app.route('/forgot_password', methods=['GET', 'POST'])
def forgot_password():
    message = None
    errors = {}
    if request.method == 'POST':
        email = request.form.get('email', '').strip()
        if not email:
            errors['email'] = "Email is required."
        else:
            conn = get_db_connection()
            cursor = conn.cursor(dictionary=True)
            cursor.execute("SELECT user_id, username FROM users WHERE email=%s", (email,))
            user = cursor.fetchone()
            cursor.close()
            conn.close()

            if not user:
                # generic message for security
                message = "If an account with that email exists, a password reset link has been sent."
                flash(message)
                return redirect(url_for('login'))
            else:
                # In production: generate token and send email
                reset_link = url_for('reset_password', username=user['username'], _external=True)
                flash("A password reset link has been (mock) sent to your email. (For demo, link shown below.)")
                return render_template('forgot_password.html', mock_link=reset_link)
    return render_template('forgot_password.html', errors=errors)


# -------------------------
# Reset password (mock; replace with token-based in production)
# -------------------------
@app.route('/reset_password/<username>', methods=['GET', 'POST'])
def reset_password(username):
    errors = {}
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT user_id FROM users WHERE username=%s", (username,))
    user = cursor.fetchone()
    if not user:
        cursor.close()
        conn.close()
        flash("Invalid reset link or user not found.")
        return redirect(url_for('login'))

    if request.method == 'POST':
        newpw = request.form.get('new_password', '')
        confirm = request.form.get('confirm_password', '')
        pw_err = validate_password(newpw)
        if pw_err:
            errors['new_password'] = pw_err
        elif newpw != confirm:
            errors['confirm_password'] = "Passwords do not match."

        if not errors:
            hashed = generate_password_hash(newpw)
            cursor.execute("UPDATE users SET password_hash=%s WHERE user_id=%s", (hashed, user['user_id']))
            conn.commit()
            cursor.close()
            conn.close()
            flash("Password reset successfully. Please log in.")
            return redirect(url_for('login'))

    cursor.close()
    conn.close()
    return render_template('reset_password.html', username=username, errors=errors)


# -------------------------
# Edit interests (owner only)
# -------------------------
@app.route('/edit_interests/<username>', methods=['GET', 'POST'])
def edit_interests(username):
    if 'username' not in session or session['username'] != username:
        flash("You are not authorized to edit this user's interests.")
        return redirect(url_for('profile_by_username', username=username))

    if request.method == 'GET':
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT genre_id, genre_name FROM genres")
        genres = cursor.fetchall()
        cursor.execute("SELECT genre_id FROM user_genres WHERE user_id=%s", (session['user_id'],))
        selected = [str(row['genre_id']) for row in cursor.fetchall()]
        cursor.close()
        conn.close()
        return render_template('edit_interests.html', genres=genres, selected=selected)

    selected_genres = request.form.getlist('interests')
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("DELETE FROM user_genres WHERE user_id=%s", (session['user_id'],))
    for gid in selected_genres:
        cursor.execute("INSERT IGNORE INTO user_genres (user_id, genre_id) VALUES (%s, %s)", (session['user_id'], gid))
    conn.commit()
    cursor.close()
    conn.close()
    flash("Interests updated.")
    return redirect(url_for('profile_by_username', username=username))


# -------------------------
# Logout
# -------------------------
@app.route("/logout")
def logout():
    session.pop("user_id", None)
    session.pop("username", None)
    session.pop("role", None)
    session.pop("user_type", None)

    flash("You have been logged out.")
    return redirect(url_for("login"))

# -------------------------
# Recommendations
# -------------------------
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

# -------------------------
# Find users
# -------------------------
@app.route("/find_users")
def find_users():
    if "user_id" not in session:
        flash("Please log in to discover people.", "error")
        return redirect(url_for("login"))

    search_query = request.args.get("q", "").strip()
    current_user_id = session["user_id"]

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    query = """
        SELECT 
            u.user_id,
            u.username,
            u.first_name,
            u.last_name,
            u.profile_image_url,
            u.bio,

            -- Are we already friends?
            COALESCE((
                SELECT 1 FROM friend_requests fr
                WHERE fr.status = 'accepted'
                  AND (
                    (fr.requester_id = %s AND fr.requestee_id = u.user_id) OR
                    (fr.requester_id = u.user_id AND fr.requestee_id = %s)
                  )
                LIMIT 1
            ), 0) AS is_friend,

            -- Did I send a pending request?
            COALESCE((
                SELECT 1 FROM friend_requests fr
                WHERE fr.status = 'pending'
                  AND fr.requester_id = %s
                  AND fr.requestee_id = u.user_id
                LIMIT 1
            ), 0) AS request_sent

        FROM users u
        WHERE u.user_id != %s
          AND u.role != 'Admin'
    """
    params = [current_user_id, current_user_id, current_user_id, current_user_id]

    if search_query:
        query += """
            AND (
                u.username LIKE %s OR 
                u.first_name LIKE %s OR 
                u.last_name LIKE %s OR 
                CONCAT(u.first_name, ' ', u.last_name) LIKE %s
            )
        """
        like = f"%{search_query}%"
        params.extend([like, like, like, like])

    query += " ORDER BY u.first_name, u.last_name LIMIT 100"

    cursor.execute(query, params)
    users = cursor.fetchall()

    # CRITICAL: Convert 1 → True, 0 → False so Jinja works
    for user in users:
        user["is_friend"] = bool(user["is_friend"])
        user["request_sent"] = bool(user["request_sent"])

    # Incoming pending requests
    cursor.execute("""
        SELECT fr.request_id, u.user_id, u.first_name, u.last_name, u.username, u.profile_image_url
        FROM friend_requests fr
        JOIN users u ON fr.requester_id = u.user_id
        WHERE fr.requestee_id = %s AND fr.status = 'pending'
        ORDER BY fr.requested_at DESC
    """, (current_user_id,))
    pending_requests = cursor.fetchall()

    cursor.execute("SELECT COUNT(*) AS total FROM users WHERE role != 'Admin'")
    total_users = cursor.fetchone()["total"]

    cursor.close()
    conn.close()

    return render_template("find_users.html",
                           users=users,
                           pending_requests=pending_requests,
                           search_query=search_query,
                           total_users=total_users)


@app.route("/send_friend_request/<int:user_id>", methods=["POST"])
def send_friend_request(user_id):
    """Send a friend request to another user"""
    if "user_id" not in session:
        flash("Please log in to send friend requests.", "error")
        return redirect(url_for("login"))
    
    current_user_id = session["user_id"]
    
    # Prevent sending request to self
    if current_user_id == user_id:
        flash("You cannot send a friend request to yourself.", "error")
        return redirect(url_for("find_users"))
    
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    # Check if target user is admin
    cursor.execute("SELECT role FROM users WHERE user_id = %s", (user_id,))
    target_user = cursor.fetchone()
    
    if not target_user:
        flash("User not found.", "error")
        cursor.close()
        conn.close()
        return redirect(url_for("find_users"))
    
    if target_user["role"] == "Admin":
        flash("Cannot send friend requests to administrators.", "error")
        cursor.close()
        conn.close()
        return redirect(url_for("find_users"))
    
    # Check for existing request
    cursor.execute("""
        SELECT status FROM friend_requests 
        WHERE (requester_id = %s AND requestee_id = %s) 
        OR (requester_id = %s AND requestee_id = %s)
    """, (current_user_id, user_id, user_id, current_user_id))
    
    existing = cursor.fetchone()
    
    if existing:
        if existing["status"] == "accepted":
            flash("You are already friends with this user.", "info")
        elif existing["status"] == "pending":
            flash("A friend request is already pending.", "info")
        else:
            # Update rejected request to pending
            cursor.execute("""
                UPDATE friend_requests 
                SET status = 'pending', requested_at = CURRENT_TIMESTAMP
                WHERE (requester_id = %s AND requestee_id = %s)
            """, (current_user_id, user_id))
            conn.commit()
            flash("Friend request sent successfully!", "success")
    else:
        # Insert new request
        cursor.execute("""
            INSERT INTO friend_requests (requester_id, requestee_id, status, requested_at)
            VALUES (%s, %s, 'pending', CURRENT_TIMESTAMP)
        """, (current_user_id, user_id))
        conn.commit()
        flash("Friend request sent successfully!", "success")
    
    cursor.close()
    conn.close()
    return redirect(url_for("find_users"))


@app.route("/accept_request/<int:request_id>", methods=["POST"])
def accept_request(request_id):
    """Accept a friend request"""
    if "user_id" not in session:
        flash("Please log in to accept friend requests.", "error")
        return redirect(url_for("login"))
    
    current_user_id = session["user_id"]
    
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    # Verify the request exists and is for the current user
    cursor.execute("""
        SELECT fr.*, u.first_name, u.last_name 
        FROM friend_requests fr
        JOIN users u ON fr.requester_id = u.user_id
        WHERE fr.request_id = %s 
        AND fr.requestee_id = %s 
        AND fr.status = 'pending'
    """, (request_id, current_user_id))
    
    request_data = cursor.fetchone()
    
    if not request_data:
        flash("Friend request not found or already processed.", "error")
        cursor.close()
        conn.close()
        return redirect(url_for("find_users"))
    
    # Update request status
    cursor.execute("""
        UPDATE friend_requests 
        SET status = 'accepted', responded_at = CURRENT_TIMESTAMP
        WHERE request_id = %s AND requestee_id = %s
    """, (request_id, current_user_id))
    
    conn.commit()
    cursor.close()
    conn.close()
    
    flash(f"You are now friends with {request_data['first_name']} {request_data['last_name']}!", "success")
    return redirect(url_for("find_users"))


@app.route("/reject_request/<int:request_id>", methods=["POST"])
def reject_request(request_id):
    """Reject a friend request"""
    if "user_id" not in session:
        flash("Please log in to reject friend requests.", "error")
        return redirect(url_for("login"))
    
    current_user_id = session["user_id"]
    
    conn = get_db_connection()
    cursor = conn.cursor()
    
    # Update request status
    cursor.execute("""
        UPDATE friend_requests 
        SET status = 'rejected', responded_at = CURRENT_TIMESTAMP
        WHERE request_id = %s AND requestee_id = %s AND status = 'pending'
    """, (request_id, current_user_id))
    
    if cursor.rowcount > 0:
        flash("Friend request rejected.", "info")
    else:
        flash("Friend request not found or already processed.", "error")
    
    conn.commit()
    cursor.close()
    conn.close()
    
    return redirect(url_for("find_users"))


@app.route("/remove_friend/<int:user_id>", methods=["POST"])
def remove_friend(user_id):
    """Remove a friend (optional - for unfriend functionality)"""
    if "user_id" not in session:
        flash("Please log in to remove friends.", "error")
        return redirect(url_for("login"))
    
    current_user_id = session["user_id"]
    
    conn = get_db_connection()
    cursor = conn.cursor()
    
    # Delete or update the friendship
    cursor.execute("""
        UPDATE friend_requests 
        SET status = 'rejected'
        WHERE ((requester_id = %s AND requestee_id = %s) 
        OR (requester_id = %s AND requestee_id = %s))
        AND status = 'accepted'
    """, (current_user_id, user_id, user_id, current_user_id))
    
    if cursor.rowcount > 0:
        flash("Friend removed successfully.", "success")
    else:
        flash("Friendship not found.", "error")
    
    conn.commit()
    cursor.close()
    conn.close()
    
    return redirect(url_for("find_users"))


@app.route("/cancel_friend_request/<int:user_id>", methods=["POST"])
def cancel_friend_request(user_id):
    """Cancel a pending friend request you sent"""
    if "user_id" not in session:
        flash("Please log in to cancel friend requests.", "error")
        return redirect(url_for("login"))

    current_user_id = session["user_id"]

    if current_user_id == user_id:
        flash("You cannot cancel a request to yourself.", "error")
        return redirect(url_for("find_users"))

    conn = get_db_connection()
    cursor = conn.cursor()

    # Delete or update the pending request
    cursor.execute("""
        DELETE FROM friend_requests 
        WHERE requester_id = %s AND requestee_id = %s AND status = 'pending'
    """, (current_user_id, user_id))

    if cursor.rowcount > 0:
        flash("Friend request cancelled.", "info")
    else:
        flash("No pending request found.", "error")

    conn.commit()
    cursor.close()
    conn.close()

    return redirect(url_for("find_users"))


# -------------------------
# Profile
# -------------------------
@app.route("/profile")
def profile_root():
    if "user_id" not in session:
        flash("Please log in first.")
        return redirect(url_for("login"))
    # redirect to user's username-specific profile
    return redirect(url_for("profile_by_username", username=session["username"]))





# # ------ DUPLICATE: older profile() variant (commented)
# @app.route('/profile/<username>')
# def profile_old(username):
#     conn = get_db_connection()
#     cursor = conn.cursor(dictionary=True)
#     cursor.execute("SELECT * FROM users WHERE username = %s", (username,))
#     user = cursor.fetchone()
#     if not user:
#         return "User not found", 404
#     cursor.execute("""
#     # ... original commented SQL ...
#     """


# -------------------------
# Author Registration
# -------------------------
@app.route("/author_register", methods=["GET", "POST"])
def author_register():
    from datetime import date
    
    form_data = {}
    errors = {}

    if request.method == "POST":
        form_data = {
            "name": request.form.get("name", "").strip(),
            "email": request.form.get("email", "").strip(),
            "password": request.form.get("password", "").strip(),
            "confirm_password": request.form.get("confirm_password", "").strip(),
            "biography": request.form.get("biography", "").strip(),
            "date_of_birth": request.form.get("date_of_birth", "").strip(),
            "date_of_death": request.form.get("date_of_death", "").strip(),
            "website": request.form.get("website", "").strip()
        }

        # Validation
        if not form_data["name"] or len(form_data["name"]) < 3:
            errors["name"] = "Name must be at least 3 characters long."
        
        if not form_data["email"]:
            errors["email"] = "Email is required."
        
        if not form_data["biography"] or len(form_data["biography"]) < 50:
            errors["biography"] = "Biography must be at least 50 characters long."
        elif len(form_data["biography"]) > 2000:
            errors["biography"] = "Biography must not exceed 2000 characters."
        
        if not form_data["date_of_birth"]:
            errors["date_of_birth"] = "Date of birth is required."
        
        # Password validation
        password_error = validate_password(form_data["password"])
        if password_error:
            errors["password"] = password_error
        elif form_data["password"] != form_data["confirm_password"]:
            errors["confirm_password"] = "Passwords do not match."

        # Date validation
        if form_data["date_of_birth"] and form_data["date_of_death"]:
            try:
                from datetime import datetime
                dob = datetime.strptime(form_data["date_of_birth"], "%Y-%m-%d")
                dod = datetime.strptime(form_data["date_of_death"], "%Y-%m-%d")
                if dod <= dob:
                    errors["date_of_death"] = "Date of death must be after date of birth."
            except ValueError:
                errors["date_of_birth"] = "Invalid date format."

        if errors:
            return render_template("author_register.html", 
                                 form_data=form_data, 
                                 errors=errors,
                                 today=date.today().isoformat())

        try:
            conn = get_db_connection()
            cursor = conn.cursor(dictionary=True)

            # Check if email already exists in authors table
            cursor.execute("SELECT * FROM authors WHERE email=%s", (form_data["email"],))
            if cursor.fetchone():
                errors["email"] = "This email is already registered as an author."
                conn.close()
                return render_template("author_register.html", 
                                     form_data=form_data, 
                                     errors=errors,
                                     today=date.today().isoformat())

            # Hash password
            hashed_pw = generate_password_hash(form_data["password"])

            # Insert into authors table
            cursor.execute("""
                INSERT INTO authors 
                (name, email, password_hash, biography, date_of_birth, date_of_death, website)
                VALUES (%s, %s, %s, %s, %s, %s, %s)
            """, (
                form_data["name"],
                form_data["email"],
                hashed_pw,
                form_data["biography"],
                form_data["date_of_birth"] or None,
                form_data["date_of_death"] or None,
                form_data["website"] or None
            ))
            
            conn.commit()
            author_id = cursor.lastrowid
            conn.close()

            # Set session for author
            session["author_id"] = author_id
            session["author_name"] = form_data["name"]
            session["author_email"] = form_data["email"]
            session["user_type"] = "author"  # Distinguish from regular users

            flash("Author account created successfully! Welcome to your dashboard.", "success")
            return redirect(url_for("author_dashboard"))

        except Error as e:
            errors["database"] = str(e)
            return render_template("author_register.html", 
                                 form_data=form_data, 
                                 errors=errors,
                                 today=date.today().isoformat())

    return render_template("author_register.html", 
                         form_data=form_data, 
                         errors=errors,
                         today=date.today().isoformat())


# -------------------------
# Author Login
# -------------------------
@app.route("/author_login", methods=["GET", "POST"])
def author_login():
    form_data = {}
    errors = {}

    if request.method == "POST":
        email = request.form.get("email", "").strip()
        password = request.form.get("password", "").strip()

        # ... (validation logic) ...

        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT * FROM authors WHERE email=%s", (email,))
        author = cursor.fetchone()
        print(f"DEBUG: Session Author ID: {author}")
        conn.close()
        print(check_password_hash(author["password_hash"], password) )

            # In author_login route:
        if author and check_password_hash(author["password_hash"], password):
            session.clear()
            # Ensure 'author_id' matches your SQL column name exactly
            session["author_id"] = author["author_id"] 
            session["author_name"] = author["name"]
            session["user_type"] = "author"
            session.modified = True 
            print(f"DEBUG: Session User Type: {session.get('user_type')}")
            print(f"DEBUG: Session Author ID: {session.get('author_id')}")
            return redirect(url_for("author_dashboard"))

        errors["email"] = "Invalid email or password."

    return render_template("author_login.html", form_data=form_data, errors=errors)

# -------------------------
# Author Logout
# -------------------------
@app.route("/author_logout")
def author_logout():
    session.pop("author_id", None)
    session.pop("author_name", None)
    session.pop("author_email", None)
    session.pop("user_type", None)
    flash("You have been logged out.", "info")
    return redirect(url_for("author_login"))


# -------------------------
# Update Author Dashboard to require authentication
# -------------------------
@app.route("/author_dashboard")
def author_dashboard():
    print(f"DEBUG: Session User Type: {session.get('user_type')}")
    print(f"DEBUG: Session Author ID: {session.get('author_id')}")
    """Dashboard for authors to view their books, reviews, and statistics"""
    # Check if logged in as author
    if "author_id" not in session or session.get("user_type") != "author":
        flash("Please log in as an author to access the dashboard.", "error")
        return redirect(url_for("author_login"))
    
    author_id = session["author_id"]
    
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    # Get author information
    cursor.execute("""
        SELECT author_id, name, email, biography, date_of_birth, date_of_death, 
               website, created_at
        FROM authors
        WHERE author_id = %s
    """, (author_id,))
    author = cursor.fetchone()
    
    if not author:
        flash("Author profile not found.", "error") #
        session.clear()
        return redirect(url_for("author_login")) #
    if session.get("user_type") != "author":
        flash("Please log in as an author.", "error")
        return redirect(url_for("author_login"))

    author_id = session.get("author_id")
    if not author_id:
        session.pop("author_id", None)
        session.pop("author_name", None)
        session.pop("author_email", None)
        session.pop("user_type", None)
        return redirect(url_for("author_login"))

    
    # author_id = session["author_id"]
    # author_id = 1

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    # Get author information
    cursor.execute("""
        SELECT author_id, name, email, biography, date_of_birth, date_of_death, 
               website, created_at
        FROM authors
        WHERE author_id = %s
    """, (author_id,))
    author = cursor.fetchone()
    
    if not author:
        flash("Author profile not found.", "error")
        session.clear()
        return redirect(url_for("author_login"))
    
    # Get author's books with statistics
    cursor.execute("""
        SELECT 
            b.book_id,
            b.title,
            b.published_year,
            b.cover_image_url,
            GROUP_CONCAT(DISTINCT g.genre_name SEPARATOR ', ') AS genres,
            COALESCE(AVG(r.ratings), 0) AS avg_rating,
            COUNT(DISTINCT r.review_id) AS review_count,
            COUNT(DISTINCT usb.shelf_id) AS shelf_count
        FROM books b
        LEFT JOIN book_genres bg ON b.book_id = bg.book_id
        LEFT JOIN genres g ON bg.genre_id = g.genre_id
        LEFT JOIN reviews r ON b.book_id = r.book_id
        LEFT JOIN user_shelf_books usb ON b.book_id = usb.book_id
        WHERE b.author_id = %s
        GROUP BY b.book_id
        ORDER BY b.published_year DESC
    """, (author_id,))
    books = cursor.fetchall()
    
    # Get total statistics
    cursor.execute("SELECT COUNT(*) AS total FROM books WHERE author_id = %s", (author_id,))
    total_books = cursor.fetchone()['total']
    
    cursor.execute("""
        SELECT COUNT(*) AS total 
        FROM reviews r
        JOIN books b ON r.book_id = b.book_id
        WHERE b.author_id = %s
    """, (author_id,))
    total_reviews = cursor.fetchone()['total']
    
    cursor.execute("""
        SELECT AVG(r.ratings) AS avg
        FROM reviews r
        JOIN books b ON r.book_id = b.book_id
        WHERE b.author_id = %s AND r.ratings IS NOT NULL
    """, (author_id,))
    avg_rating = cursor.fetchone()['avg'] or 0
    
    cursor.execute("""
        SELECT COUNT(DISTINCT usb.shelf_id) AS total
        FROM user_shelf_books usb
        JOIN books b ON usb.book_id = b.book_id
        WHERE b.author_id = %s
    """, (author_id,))
    total_readers = cursor.fetchone()['total']
    
    # Get recent reviews
    cursor.execute("""
        SELECT 
            r.ratings,
            r.review_text,
            r.review_date,
            u.username,
            b.title AS book_title,
            b.book_id
        FROM reviews r
        JOIN users u ON r.user_id = u.user_id
        JOIN books b ON r.book_id = b.book_id
        WHERE b.author_id = %s
        ORDER BY r.review_date DESC
        LIMIT 10
    """, (author_id,))
    recent_reviews = cursor.fetchall()
    
    # Get recent activity
    cursor.execute("""
        SELECT 
            'review' AS type,
            CONCAT(u.username, ' reviewed "', b.title, '"') AS text,
            r.review_date AS time
        FROM reviews r
        JOIN users u ON r.user_id = u.user_id
        JOIN books b ON r.book_id = b.book_id
        WHERE b.author_id = %s
        UNION ALL
        SELECT 
            'shelf' AS type,
            CONCAT('A reader added "', b.title, '" to their shelf') AS text,
            usb.added_date AS time
        FROM user_shelf_books usb
        JOIN books b ON usb.book_id = b.book_id
        WHERE b.author_id = %s
        ORDER BY time DESC
        LIMIT 15
    """, (author_id, author_id))
    recent_activity = cursor.fetchall()
    
    # Format activity times
    for activity in recent_activity:
        from datetime import datetime, timedelta
        now = datetime.now()
        diff = now - activity['time']
        
        if diff < timedelta(minutes=1):
            activity['time'] = "just now"
        elif diff < timedelta(hours=1):
            activity['time'] = f"{int(diff.total_seconds() / 60)} minutes ago"
        elif diff < timedelta(days=1):
            activity['time'] = f"{int(diff.total_seconds() / 3600)} hours ago"
        elif diff < timedelta(days=7):
            activity['time'] = f"{diff.days} days ago"
        else:
            activity['time'] = activity['time'].strftime("%b %d, %Y")
    
    cursor.close()
    conn.close()
    
    return render_template("author_dashboard.html",
                         author=author,
                         books=books,
                         total_books=total_books,
                         total_reviews=total_reviews,
                         avg_rating=round(avg_rating, 2),
                         total_readers=total_readers,
                         recent_reviews=recent_reviews,
                         recent_activity=recent_activity)


# -------------------------
# Author Profile Edit
# -------------------------
@app.route("/author_profile/edit", methods=["GET", "POST"])
def edit_author_profile():
    if "author_id" not in session or session.get("user_type") != "author":
        flash("Please log in as an author.", "error")
        return redirect(url_for("author_login"))
    
    author_id = session["author_id"]
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    if request.method == "POST":
        name = request.form.get("name", "").strip()
        biography = request.form.get("biography", "").strip()
        website = request.form.get("website", "").strip()
        
        errors = {}
        if not name or len(name) < 3:
            errors["name"] = "Name must be at least 3 characters."
        if not biography or len(biography) < 50:
            errors["biography"] = "Biography must be at least 50 characters."
        
        if not errors:
            cursor.execute("""
                UPDATE authors 
                SET name=%s, biography=%s, website=%s
                WHERE author_id=%s
            """, (name, biography, website or None, author_id))
            conn.commit()
            
            session["author_name"] = name
            flash("Profile updated successfully!", "success")
            conn.close()
            return redirect(url_for("author_dashboard"))
        
        conn.close()
        return render_template("edit_author_profile.html", errors=errors, 
                             author={"name": name, "biography": biography, "website": website})
    
    cursor.execute("SELECT * FROM authors WHERE author_id=%s", (author_id,))
    author = cursor.fetchone()
    conn.close()
    
    return render_template("edit_author_profile.html", author=author, errors={})


# -------------------------
# Run app
# -------------------------
if __name__ == "__main__":
    app.run(debug=True)
