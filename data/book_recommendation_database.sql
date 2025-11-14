-- Create database
CREATE DATABASE books_db;
USE books_db;
-- drop database books_db;

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
  profile_image_url VARCHAR(255),
  role ENUM('Admin', 'Reader') NOT NULL DEFAULT 'Reader'
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

INSERT INTO authors (name, biography, date_of_birth, date_of_death) VALUES
-- ('Premchand', 'Pioneer of modern Hindi fiction, wrote social realism novels like Godaan.', '1880-07-31', '1936-10-08'),
-- ('J.K. Rowling', 'British author of the Harry Potter fantasy series.', '1965-07-31', NULL),
-- ('Vishnu Sakharam Khandekar', 'Marathi novelist, first Marathi author to win Jnanpith Award.', '1898-01-11', '1976-09-02'),
-- ('Yuval Noah Harari', 'Israeli historian and author of Sapiens and Homo Deus.', '1976-02-24', NULL),
-- ('Ramachandra Guha', 'Indian historian and biographer.', '1958-04-29', NULL),
-- ('Nandini Nair', 'Indian author of popular science and non-fiction books.', '1975-08-10', NULL),
-- ('Nicholas Sparks', 'American novelist known for romance novels like The Notebook.', '1965-12-31', NULL),
-- ('Jane Austen', 'English author famous for Pride and Prejudice and other romance novels.', '1775-12-16', '1817-07-18'),
-- ('Manju Kapur', 'Hindi/English novelist known for romance and family dramas.', '1948-12-22', NULL),
-- ('Dan Brown', 'American author of thriller novels like The Da Vinci Code.', '1964-06-22', NULL),
-- ('Satyajit Ray', 'Indian filmmaker and author of thriller stories (Feluda series).', '1921-05-02', '1992-04-23'),
-- ('Abir Mukherjee', 'English crime and thriller novelist.', '1974-03-18', NULL),
-- ('Robert Hughes', 'Art critic and author of The Shock of the New.', '1938-07-28', '2012-08-06'),
-- ('Subodh Gupta', 'Contemporary Indian artist and writer on modern Indian art.', '1964-11-04', NULL),
-- ('Stephen King', 'American author of horror, supernatural fiction, and thrillers.', '1947-09-21', NULL),
-- ('Ramdhari Singh Dinkar', 'Hindi poet and writer who explored darker themes.', '1908-09-23', '1974-04-24'),
-- ('J.R.R. Tolkien', 'British author of The Lord of the Rings and The Hobbit.', '1892-01-03', '1973-09-02'),
-- ('C.S. Lewis', 'British author of The Chronicles of Narnia series.', '1898-11-29', '1963-11-22'),
-- ('Amish Tripathi', 'Indian author known for the Shiva Trilogy, fantasy novels in English.', '1974-10-18', NULL),
-- ('Suzanne Collins', 'American author of The Hunger Games series.', '1962-08-10', NULL),
-- ('Raina Telgemeier', 'Graphic novelist for young adults.', '1977-05-26', NULL),
-- ('Anuja Chauhan', 'Indian novelist writing YA/fiction in English and Hindi.', '1970-06-10', NULL),
-- ('Stan Lee', 'American comic book writer, editor, and publisher, co-created Marvel superheroes.', '1922-12-28', '2018-11-12'),
-- ('R.K. Laxman', 'Indian cartoonist, creator of The Common Man.', '1921-10-24', '2015-01-26'),
-- ('Walter Isaacson', 'American author of biographies on Steve Jobs, Einstein, Leonardo da Vinci.', '1952-05-20', NULL),
-- ('Ramachandra Guha', 'Indian historian and biographer.', '1958-04-29', NULL),
-- ('Khushwant Singh', 'Indian writer and biographer.', '1915-02-02', '2014-03-20'),
-- ('William Dalrymple', 'British historian and author of books on Indian history.', '1965-05-20', NULL),
-- ('Irfan Habib', 'Indian historian specializing in medieval India.', '1931-08-03', NULL),
-- ('Bipan Chandra', 'Indian historian and author of modern Indian history books.', '1928-08-14', '2014-08-30'),
-- ('Abhinav Bindra', 'Indian Olympic gold medalist, author of autobiography on sports and life.', '1982-09-28', NULL),
-- ('Sachin Tendulkar', 'Indian cricketer, author of autobiography and sports books.', '1973-04-24', NULL),
-- ('Venkat Subramaniam', 'Author of sports analytics and performance books.', '1975-02-15', NULL),
-- ('J.K. Rowling', 'British author of the Harry Potter fantasy series, philanthropist, and film producer.','1965-07-31',null),
-- ('George R.R. Martin','American author known for the A Song of Ice and Fire series, basis for Game of Thrones.','1948-09-20',NULL),
-- ('Ana Huang','Contemporary romance novelist, known for the Twisted series and other romance novels.', NUll, null),
-- ('Amish Tripathi','Indian author of mythological fantasy novels, including the Shiva Trilogy.','1974-10-18',NULL),
-- ('Suzanne Collins','American author of young adult fiction, best known for The Hunger Games trilogy.','1962-08-10',NULL),
-- ('J.R.R. Tolkien','British author, philologist, and academic, known for epic high-fantasy novels including The Lord of the Rings.','1892-01-03', '1973-09-02');
('Premchand', 'Pioneer of modern Hindi fiction, wrote social realism novels like Godaan.', '1880-07-31', '1936-10-08'),
('J.K. Rowling', 'British author of the Harry Potter fantasy series.', '1965-07-31', NULL),
('Vishnu Sakharam Khandekar', 'Marathi novelist, first Marathi author to win Jnanpith Award.', '1898-01-11', '1976-09-02'),
('Yuval Noah Harari', 'Israeli historian and author of Sapiens and Homo Deus.', '1976-02-24', NULL),
('Ramachandra Guha', 'Indian historian and biographer.', '1958-04-29', NULL),
('Jane Austen', 'English author famous for Pride and Prejudice and other romance novels.', '1775-12-16', '1817-07-18'),
('Dan Brown', 'American author of thriller novels like The Da Vinci Code.', '1964-06-22', NULL),
('Satyajit Ray', 'Indian filmmaker and author of thriller stories (Feluda series).', '1921-05-02', '1992-04-23'),
('Robert Hughes', 'Art critic and author of The Shock of the New.', '1938-07-28', '2012-08-06'),
('Subodh Gupta', 'Contemporary Indian artist and writer on modern Indian art.', '1964-11-04', NULL),
('Stephen King', 'American author of horror, supernatural fiction, and thrillers.', '1947-09-21', NULL),
('Ramdhari Singh Dinkar', 'Hindi poet and writer who explored darker themes.', '1908-09-23', '1974-04-24'),
('J.R.R. Tolkien', 'British author of The Lord of the Rings and The Hobbit.', '1892-01-03', '1973-09-02'),
('C.S. Lewis', 'British author of The Chronicles of Narnia series.', '1898-11-29', '1963-11-22'),
('Amish Tripathi', 'Indian author known for the Shiva Trilogy, fantasy novels in English.', '1974-10-18', NULL),
('Suzanne Collins', 'American author of The Hunger Games series.', '1962-08-10', NULL),
('Anuja Chauhan', 'Indian novelist writing YA/fiction in English and Hindi.', '1970-06-10', NULL),
('Stan Lee', 'American comic book writer, co-creator of Marvel superheroes.', '1922-12-28', '2018-11-12'),
('R.K. Laxman', 'Indian cartoonist, creator of The Common Man.', '1921-10-24', '2015-01-26'),
('Walter Isaacson', 'American author of biographies on Steve Jobs, Einstein, Leonardo da Vinci.', '1952-05-20', NULL),
('Khushwant Singh', 'Indian writer and biographer.', '1915-02-02', '2014-03-20'),
('William Dalrymple', 'British historian and author of books on Indian history.', '1965-05-20', NULL),
('Irfan Habib', 'Indian historian specializing in medieval India.', '1931-08-03', NULL),
('Bipan Chandra', 'Indian historian and author of modern Indian history books.', '1928-08-14', '2014-08-30'),
('Abhinav Bindra', 'Indian Olympic gold medalist, author of autobiography.', '1982-09-28', NULL),
('Sachin Tendulkar', 'Indian cricketer, author of autobiography and sports books.', '1973-04-24', NULL),
('George R.R. Martin','American author known for the A Song of Ice and Fire series.', '1948-09-20', NULL),
('Ana Huang','Contemporary romance novelist, known for the Twisted series.', NULL, NULL);

select * from authors;

-- Series table (books may belong to a series)
CREATE TABLE series (
  series_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT
);
INSERT INTO series (name, description) VALUES
('Harry Potter', 'Fantasy series about a young wizard and his adventures at Hogwarts.'),
('Game of Thrones', 'Epic fantasy series set in the Seven Kingdoms of Westeros.'),
('Twisted', 'Contemporary romance series by Ana Huang.'),
('Shiva Trilogy', 'Indian mythological fantasy series about Lord Shiva.'),
('The Hunger Games', 'Dystopian young adult series set in Panem.'),
('The Lord of the Rings', 'Epic high-fantasy trilogy.'),
('Standalone', 'Books not part of a series.');
select * from series;
-- Genres table
CREATE TABLE genres (
  genre_id INT AUTO_INCREMENT PRIMARY KEY,
  genre_name VARCHAR(100) UNIQUE NOT NULL
);
-- drop table genres;

INSERT INTO genres (genre_name) VALUES
-- ('Fiction'), ('Non-Fiction'), ('Fantasy'), ('Epic Fantasy'), ('Urban Fantasy'),
-- ('Dark Fantasy'), ('Sword & Sorcery'), ('Science Fiction'), ('Hard Science Fiction'), ('Space Opera'), 
-- ('Dystopian'), ('Cyberpunk'), ('Steampunk'), ('Mystery'), ('Detective Fiction'),
-- ('Cozy Mystery'), ('Crime Thriller'), ('Thriller'), ('Psychological Thriller'), ('Legal Thriller'),
-- ('Political Thriller'), ('Techno-Thriller'), ('Horror'), ('Gothic Horror'), ('Paranormal Horror'),
-- ('Supernatural Horror'), ('Romance'), ('Contemporary Romance'), ('Historical Romance'), ('Paranormal Romance'),
-- ('Romantic Suspense'), ('LGBTQ+ Romance'), ('Historical Fiction'), ('Adventure'), ('Drama'),
-- ('Literary Fiction'), ('Magical Realism'), ('Young Adult'), ('YA Fantasy'), ('YA Romance'),
-- ('YA Science Fiction'), ('Children’s Fiction'), ('Picture Books'), ('Middle Grade'), ('Graphic Novels'),
-- ('Comics'), ('Biography'), ('Autobiography'), ('Memoir'), ('Self-Help'),
-- ('Personal Development'), ('Philosophy'), ('Psychology'), ('Religion & Spirituality'), ('History'),
-- ('Politics'), ('Science'), ('Technology'), ('Health & Fitness'), ('Business'),
-- ('Economics'), ('Education'), ('Travel'), ('True Crime'), ('Essays'),
-- ('Cookbooks'), ('Food Writing'), ('Art'), ('Photography'), ('Music'),
-- ('Sports'), ('Reference'), ('Poetry'), ('Anthology'), ('Short Stories'),
-- ('Classic Literature'), ('Humor'), ('Satire'), ('Westerns'), ('War'), 
-- ('Military'), ('LGBTQ+ Literature');
('Fiction'), ('Non-Fiction'), ('Fantasy'), ('Epic Fantasy'), ('Romance'),
('Mystery'), ('Thriller'), ('Horror'), ('Biography'), ('History'),
('Young Adult'), ('Children’s Fiction'), ('Graphic Novels'), ('Comics');

select * from genres;

-- Books table
CREATE TABLE books (
  book_id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  author_id INT,
  series_id INT,
  published_year INT,
  language enum('English','Hindi','Gujarati','Marathi') not null, 
  description TEXT,
  cover_image_url VARCHAR(255),
  isbn VARCHAR(20),        -- for external lookup
  -- avg_rating FLOAT DEFAULT 0.0,
--   num_ratings INT DEFAULT 0,
  FOREIGN KEY (author_id) REFERENCES authors(author_id),
  FOREIGN KEY (series_id) REFERENCES series(series_id)
);

INSERT INTO books (title, author_id, series_id, published_year, language, description, cover_image_url, isbn) VALUES
-- ('Godaan', 1, NULL, 1936, 'Hindi', 'Classic Hindi novel on rural India and social issues.', '', '9788171673135'),
-- ('Harry Potter and the Philosopher''s Stone', 2, NULL, 1997, 'English', 'The first book in the Harry Potter fantasy series.', '', '9780747532699'),
-- ('Yayati', 3, NULL, 1959, 'Marathi', 'Retelling of the ancient mythological story of Yayati.', '', '9788171824506'),
-- ('Sapiens: A Brief History of Humankind', 4, NULL, 2011, 'English', 'History and impact of Homo sapiens.', '', '9780099590088'),
-- ('India After Gandhi', 5, NULL, 2007, 'English', 'Comprehensive history of India post-independence.', '', '9780312421036'),
-- ('Pride and Prejudice', 6, NULL, 1813, 'English', 'Classic romance novel by Jane Austen.', '', '9780141439518'),
-- ('Dilli ki Prem Kahani', 7, NULL, 2005, 'Hindi', 'Modern Hindi romance novel.', '', '9788175307203'),
-- ('The Da Vinci Code', 8, NULL, 2003, 'English', 'Mystery thriller about secret societies.', '', '9780385504201'),
-- ('Feluda Samagra', 9, NULL, 1980, 'Hindi', 'Detective stories by Satyajit Ray.', '', '9788172239565'),
-- ('The Shock of the New', 10, NULL, 1980, 'English', 'Critical analysis of modern art.', '', '9780140095273'),
-- ('Indian Contemporary Art', 11, NULL, 2010, 'English', 'Works and life of contemporary Indian artists.', '', '9788174363740'),
-- ('It', 12, NULL, 1986, 'English', 'Horror novel by Stephen King.', '', '9780670813025'),
-- ('Rashmirathi', 13, NULL, 1952, 'Hindi', 'Epic Hindi poem with dark, mythological themes.', '', '9788171670035'),
-- ('The Lord of the Rings: Fellowship of the Ring', 14, NULL, 1954, 'English', 'Epic fantasy novel by Tolkien.', '', '9780261103573'),
-- ('The Chronicles of Narnia: The Lion, the Witch and the Wardrobe', 15, NULL, 1950, 'English', 'Fantasy novel by C.S. Lewis.', '', '9780064471046'),
-- ('Shiva Trilogy: The Immortals of Meluha', 16, NULL, 2010, 'English', 'Indian mythological fantasy novel.', '', '9780143425058'),
-- ('The Hunger Games', 17, NULL, 2008, 'English', 'Dystopian YA novel by Suzanne Collins.', '', '9780439023528'),
-- ('Gattu Ke Safar', 18, NULL, 2012, 'Hindi', 'Young adult novel by Anuja Chauhan.', '', '9788184950701'),
-- ('Marvel Comics: Spider-Man', 19, NULL, 1962, 'English', 'Classic Marvel superhero comics.', '', '9780785198192'),
-- ('The Common Man Cartoons', 20, NULL, 1951, 'Marathi', 'Cartoon series by R.K. Laxman.', '', '9788172245177'),
-- ('Steve Jobs', 21, NULL, 2011, 'English', 'Biography of Steve Jobs by Walter Isaacson.', '', '9781451648539'),
-- ('Khushwant Singh: The History of Sikhs', 22, NULL, 2003, 'English', 'Biography and historical accounts.', '', '9788171670448'),
-- ('The Last Mughal', 23, NULL, 2006, 'English', 'History of the last Mughal emperor.', '', '9780143036002'),
-- ('India: 1857', 24, NULL, 2007, 'English', 'Historical account by Irfan Habib.', '', '9780195678149'),
-- ('Playing It My Way', 25, NULL, 2014, 'English', 'Autobiography of Sachin Tendulkar.', '', '9780349406429'),
-- ('A Shot at History', 26, NULL, 2011, 'English', 'Abhinav Bindra autobiography and sports insights.', '', '9781408803488');
('Godaan', 1, 7, 1936, 'Hindi', 'Classic Hindi novel on rural India and social issues.', 'static/images/godaan.png', '9788171673135'),
('Harry Potter and the Philosopher''s Stone', 2, 1, 1997, 'English', 'The first book in the Harry Potter series.', 'https://covers.openlibrary.org/b/isbn/9780747532699-M.jpg', '9780747532699'),
('Yayati', 3, 7, 1959, 'Marathi', 'Retelling of mythological story of Yayati.', 'static/images/yayati.png', '9788171824506'),
('Sapiens: A Brief History of Humankind', 4, 7, 2011, 'English', 'History and impact of Homo sapiens.', 'https://covers.openlibrary.org/b/isbn/9780099590088-M.jpg', '9780099590088'),
('India After Gandhi', 5, 7, 2007, 'English', 'History of India post-independence.', 'static/images/india_after_gandhi.png', '9780312421036'),
('Pride and Prejudice', 6, 7, 1813, 'English', 'Classic romance novel by Jane Austen.', 'https://covers.openlibrary.org/b/isbn/9780141439518-M.jpg', '9780141439518'),
('The Da Vinci Code', 7, 7, 2003, 'English', 'Mystery thriller about secret societies.', 'https://covers.openlibrary.org/b/isbn/9780385504201-M.jpg', '9780385504201'),
('Feluda Samagra', 8, 7, 1980, 'Hindi', 'Detective stories by Satyajit Ray.', 'static/images/no_cover.png', '9788172239565'),
('The Shock of the New', 9, 7, 1980, 'English', 'Critical analysis of modern art.', 'static/images/the_shock_of_the_new.png', '9780140095273'),
('It', 11, 7, 1986, 'English', 'Horror novel by Stephen King.', 'https://covers.openlibrary.org/b/isbn/9780670813025-M.jpg', '9780670813025'),
('Rashmirathi', 12, 7, 1952, 'Hindi', 'Epic Hindi poem with mythological themes.', 'static/images/no_cover.png', '9788171670035'),
('The Fellowship of the Ring', 13, 6, 1954, 'English', 'First book of The Lord of the Rings.', 'https://covers.openlibrary.org/b/isbn/9780261103573-M.jpg', '9780261103573'),
('The Lion, the Witch and the Wardrobe', 14, 7, 1950, 'English', 'Chronicles of Narnia fantasy novel.', 'https://covers.openlibrary.org/b/isbn/9780064471046-M.jpg', '9780064471046'),
('The Immortals of Meluha', 15, 4, 2010, 'English', 'First book of the Shiva Trilogy.', 'static/images/no_cover.png', '9780143425058'),
('The Hunger Games', 16, 5, 2008, 'English', 'Dystopian YA novel.', 'https://covers.openlibrary.org/b/isbn/9780439023528-M.jpg', '9780439023528'),
('Marvel Comics: Spider-Man', 18, 7, 1962, 'English', 'Classic Marvel superhero comics.', 'static/images/no_cover.png', '9780785198192'),
('The Common Man Cartoons', 19, 7, 1951, 'Marathi', 'Cartoon series by R.K. Laxman.', 'https://covers.openlibrary.org/b/isbn/9788172245177-M.jpg', '9788172245177'),
('Steve Jobs', 20, 7, 2011, 'English', 'Biography of Steve Jobs by Walter Isaacson.', 'https://covers.openlibrary.org/b/isbn/9781451648539-M.jpg', '9781451648539'),
('The History of Sikhs', 21, 7, 2003, 'English', 'Historical biography by Khushwant Singh.', 'static/images/no_cover.png', '9788171670448'),
('The Last Mughal', 22, 7, 2006, 'English', 'History of the last Mughal emperor.', 'static/images/no_cover.png', '9780143036002'),
('India: 1857', 23, 7, 2007, 'English', 'Historical account by Irfan Habib.', 'static/images/no_cover.png', '9780195678149'),
('Playing It My Way', 25, 7, 2014, 'English', 'Autobiography of Sachin Tendulkar.', 'static/images/no_cover.png', '9780349406429'),
('A Song of Ice and Fire: A Game of Thrones', 27, 2, 1996, 'English', 'First book of A Song of Ice and Fire.', 'https://covers.openlibrary.org/b/isbn/9780553103540-M.jpg', '9780553103540'),
('Twisted Love', 28, 3, 2021, 'English', 'First book in the Twisted romance series.', 'https://covers.openlibrary.org/b/isbn/9781728274867-M.jpg', '9781728274867');

select * from books;
-- drop table books;
-- Book <-> Genre many-to-many table (a book can belong to multiple genres)
CREATE TABLE book_genres (
  book_id INT,
  genre_id INT,
  PRIMARY KEY (book_id, genre_id),
  FOREIGN KEY (book_id) REFERENCES books(book_id),
  FOREIGN KEY (genre_id) REFERENCES genres(genre_id)
);
INSERT INTO book_genres (book_id, genre_id) VALUES 
(1, 1),
(2, 3), (2, 11), (2, 12),
(3, 1), (3, 4),
(4, 2), (4, 10),
(5, 2), (5, 10),
(6, 1), (6, 5),
(7, 1), (7, 6), (7, 7),
(8, 1), (8, 6),
(9, 2),
(10, 1), (10, 8),
(11, 1),
(12, 3), (12, 4),
(13, 3), (13, 11), (13, 12),
(14, 3), (14, 4),
(15, 11), (15, 3),
(16, 14), (16, 13),
(17, 14), (17, 13),
(18, 9), (18, 2),
(19, 10), (19, 9),
(20, 10), (20, 2),
(21, 10), (21, 2),
(22, 9), (22, 2),
(23, 3), (23, 4),
(24, 1), (24, 5);
-- drop table book_genres;

CREATE TABLE user_genres (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  genre_id INT NOT NULL,
  UNIQUE (user_id, genre_id),
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (genre_id) REFERENCES genres(genre_id)
);

select * from user_genres;
-- drop table user_genres;

create table user_search_history (
  history_id int auto_increment primary key,
  user_id int,
  search_query varchar(255),
  -- book_id INT,  -- optional, if the query matched a book
  search_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(user_id)
  -- FOREIGN KEY (book_id) REFERENCES books(book_id)
);
-- drop table user_search_history;
-- ---------------------------------------------------------
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
