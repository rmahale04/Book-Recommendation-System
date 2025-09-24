-- Create database
-- drop database books; 
CREATE DATABASE books;
USE books;
drop database books_db;

-- Users table
CREATE TABLE users (
  user_id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(100) UNIQUE NOT NULL,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  join_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  bio TEXT,
  profile_image_url VARCHAR(255)
);

select * from users;

-- Authors table
CREATE TABLE authors (
  author_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  biography TEXT,
  date_of_birth DATE,
  date_of_death DATE
);

-- Series table (books may belong to a series)
CREATE TABLE series (
  series_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT
);

-- Genres table
CREATE TABLE genres (
  genre_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) UNIQUE NOT NULL
);

-- Books table
CREATE TABLE books (
  book_id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  author_id INT,
  series_id INT,
  published_year INT,
  description TEXT,
  cover_image_url VARCHAR(255),
  isbn VARCHAR(20),        -- for external lookup
  avg_rating FLOAT DEFAULT 0.0,
  num_ratings INT DEFAULT 0,
  FOREIGN KEY (author_id) REFERENCES authors(author_id),
  FOREIGN KEY (series_id) REFERENCES series(series_id)
);

-- Book <-> Genre many-to-many table (a book can belong to multiple genres)
CREATE TABLE book_genres (
  book_id INT,
  genre_id INT,
  PRIMARY KEY (book_id, genre_id),
  FOREIGN KEY (book_id) REFERENCES books(book_id),
  FOREIGN KEY (genre_id) REFERENCES genres(genre_id)
);

-- Shelves table (types of shelves e.g. “Read”, “Want to Read”, “Currently Reading”, or custom by user)
CREATE TABLE shelves (
  shelf_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT,
  name VARCHAR(100) NOT NULL,
  is_default BOOLEAN DEFAULT FALSE,  -- for built-in shelves
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- User’s books on shelves (which book is on which shelf of which user)
CREATE TABLE user_shelf_books (
  shelf_id INT,
  book_id INT,
  added_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (shelf_id, book_id),
  FOREIGN KEY (shelf_id) REFERENCES shelves(shelf_id),
  FOREIGN KEY (book_id) REFERENCES books(book_id)
);

-- Ratings (user gives a numeric rating to a book)
CREATE TABLE ratings (
  rating_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT,
  book_id INT,
  rating DECIMAL(2,1) CHECK (rating BETWEEN 1 AND 5),  -- e.g. 4.5 allowed
  rating_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (book_id) REFERENCES books(book_id)
);

-- Reviews (user writes textual review for a book)
CREATE TABLE reviews (
  review_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT,
  book_id INT,
  review_text TEXT,
  review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (book_id) REFERENCES books(book_id)
);

--  Friendships between users
  CREATE TABLE friendships (
   user_id INT,
   friend_user_id INT,
   status ENUM('pending', 'accepted', 'declined') DEFAULT 'pending',
   request_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
   PRIMARY KEY (user_id, friend_user_id),
   FOREIGN KEY (user_id) REFERENCES users(user_id),
   FOREIGN KEY (friend_user_id) REFERENCES users(user_id)
);
 
-- Tags table (users can tag books, or books can have tags)
CREATE TABLE tags (
  tag_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) UNIQUE NOT NULL
);

-- Many-to-many between books & tags
CREATE TABLE book_tags (
  book_id INT,
  tag_id INT,
  PRIMARY KEY (book_id, tag_id),
  FOREIGN KEY (book_id) REFERENCES books(book_id),
  FOREIGN KEY (tag_id) REFERENCES tags(tag_id)
);

-- Quotes (Goodreads has quotes from books, with votes maybe)
-- CREATE TABLE quotes (
--   quote_id INT AUTO_INCREMENT PRIMARY KEY,
--   book_id INT,
--   user_id INT,     -- maybe the user who submitted it
--   quote_text TEXT,
--   added_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
--   FOREIGN KEY (book_id) REFERENCES books(book_id),
--   FOREIGN KEY (user_id) REFERENCES users(user_id)
-- );

-- Votes for quotes (users upvote quotes)
-- CREATE TABLE quote_votes (
--   quote_id INT,
--   user_id INT,
--   vote_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
--   PRIMARY KEY (quote_id, user_id),
--   FOREIGN KEY (quote_id) REFERENCES quotes(quote_id),
--   FOREIGN KEY (user_id) REFERENCES users(user_id)
-- );
