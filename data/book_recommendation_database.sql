-- Create database
-- drop database books_db; 
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

insert into users(username,first_name,last_name,email,password_hash,join_date)values
('Netra321','Netra','patel','netrajigneshpatel@gmail.com','scrypt:32768:8:1$tQVT1oK7iMACd92W$e2962590852ca703af99fdb190c01c9da0a1e61fbd64e04d9d992837753fa9dbfe0e0af6f1384ac673985b5ec26e2413d9417224e607546a247b945d440d0051','2025-10-28 16:49:39');#Netra@321

insert into users(username,first_name,last_name,email,password_hash,join_date,role)values
('admin','abc','def','admin@gmail.com','$42d6bb0e669ad8eaffb3bb860a2ff6d20f9d450290529b116a2d1febbc62c119d8bd16213c3a1f48035f7759a3926acaf5a0a3b820fe80334866cda91cc4ba8d','2025-10-31 11:55:31','Admin');#Admin@123


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


INSERT INTO authors (name, biography, date_of_birth, date_of_death) VALUES
('Colleen Hoover', 'American author of contemporary romance and emotional fiction.', '1979-12-11', NULL),
('Sarah J. Maas', 'American fantasy author, known for ACOTAR and TOG series.', '1986-03-05', NULL),
('Brandon Sanderson', 'American epic fantasy author, Mistborn and Cosmere universe.', '1975-12-19', NULL),
('Ravinder Singh', 'Indian romance author known for emotional love stories.', '1982-02-04', NULL),
('John Green', 'American author of YA novels like The Fault in Our Stars.', '1977-08-24', NULL),
('Veronica Roth', 'American YA author known for Divergent series.', '1988-08-19', NULL),
('Paulo Coelho', 'Brazilian novelist known for The Alchemist.', '1947-08-24', NULL),
('Khaled Hosseini', 'Afghan-American novelist known for The Kite Runner.', '1965-03-04', NULL),
('Haruki Murakami', 'Japanese author known for surreal fiction.', '1949-01-12', NULL),
('Ruskin Bond', 'Indian author of children’s and fiction books.', '1934-05-19', NULL),
('Chetan Bhagat', 'Indian author of contemporary fiction.', '1974-04-22', NULL),
('Rick Riordan', 'American author of Percy Jackson series.', '1964-06-05', NULL),
('Taylor Jenkins Reid', 'American author known for celebrity-driven fiction.', '1983-12-20', NULL),
('Jojo Moyes', 'British romance author.', '1969-08-04', NULL),
('Elif Shafak', 'Turkish-British novelist known for multicultural themes.', '1971-10-25', NULL);


-- 1. Insert new Authors (IDs will start from 44 based on your file)
INSERT INTO authors (name, biography, date_of_birth, date_of_death) VALUES
('Agatha Christie', 'British writer known for her 66 detective novels.', '1890-09-15', '1976-01-12'), -- ID 44
('Arthur Conan Doyle', 'British writer, creator of Sherlock Holmes.', '1859-05-22', '1930-07-07'),    -- ID 45
('George Orwell', 'English novelist, essayist, journalist and critic.', '1903-06-25', '1950-01-21'),    -- ID 46
('Harper Lee', 'American novelist known for To Kill a Mockingbird.', '1926-04-28', '2016-02-19'),       -- ID 47
('F. Scott Fitzgerald', 'American novelist of the Jazz Age.', '1896-09-24', '1940-12-21'),              -- ID 48
('Sudha Murty', 'Indian educator, author and philanthropist.', '1950-08-19', NULL),                     -- ID 49
('A.P.J. Abdul Kalam', 'Indian aerospace scientist and statesman.', '1931-10-15', '2015-07-27'),        -- ID 50
('Arundhati Roy', 'Indian author and political activist.', '1961-11-24', NULL),                         -- ID 51
('Frank Herbert', 'American science fiction author.', '1920-10-08', '1986-02-11'),                      -- ID 52
('Gillian Flynn', 'American author known for thriller novels.', '1971-02-24', NULL),                    -- ID 53
('Alex Michaelides', 'Cypriot-American author of thrillers.', '1977-09-04', NULL),                      -- ID 54
('Fyodor Dostoevsky', 'Russian novelist and philosopher.', '1821-11-11', '1881-02-09'),                 -- ID 55
('Gabriel García Márquez', 'Colombian novelist and Nobel laureate.', '1927-03-06', '2014-04-17');       -- ID 56

select * from authors;

-- Series table (books may belong to a series)
CREATE TABLE series (
  series_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT
);
INSERT INTO Series (name, description) VALUES
('Harry Potter', 'Fantasy series about a young wizard and his adventures at Hogwarts.'),
('Game of Thrones', 'Epic fantasy series set in the Seven Kingdoms of Westeros.'),
('Twisted', 'Contemporary romance series by Ana Huang.'),
('Shiva Trilogy', 'Indian mythological fantasy series about Lord Shiva.'),
('The Hunger Games', 'Dystopian young adult series set in Panem.'),
('The Lord of the Rings', 'Epic high-fantasy trilogy.'),
('Standalone', 'Books not part of a series.'),
('ACOTAR', 'A Court of Thorns and Roses fantasy romance series.'),
('Mistborn', 'Epic fantasy series by Brandon Sanderson.'),
('Percy Jackson', 'Greek mythology-based YA fantasy series.'),
('Divergent', 'YA dystopian series by Veronica Roth.');

INSERT INTO series (name, description) VALUES
('Hercule Poirot', 'Mystery series featuring the Belgian detective Hercule Poirot.'),
('Sherlock Holmes', 'Classic detective stories featuring Sherlock Holmes and Dr. Watson.'),
('Dune Saga', 'Epic science fiction series set in the distant future.');


select * from series;


-- Genres table
CREATE TABLE genres (
  genre_id INT AUTO_INCREMENT PRIMARY KEY,
  genre_name VARCHAR(100) UNIQUE NOT NULL
);
-- drop table genres;

INSERT INTO genres (genre_name) VALUES
('Fiction'), ('Non-Fiction'), ('Fantasy'), ('Epic Fantasy'), ('Romance'),
('Mystery'), ('Thriller'), ('Horror'), ('Biography'), ('History'),
('Young Adult'), ('Children’s Fiction'), ('Graphic Novels'), ('Comics');

INSERT INTO genres (genre_name) VALUES
('Contemporary Fiction'),
('Mythological Fiction'),
('Surreal Fiction'),
('High Fantasy'),
('Dark Romance');


select * from genres;


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
('Rashmirathi', 12, 7, 1952, 'Hindi', 'Epic Hindi poem with mythological themes.', 'https://m.media-amazon.com/images/S/compressed.photo.goodreads.com/books/1678616805i/92258500.jpg', '9788171670035'),
('The Fellowship of the Ring', 13, 6, 1954, 'English', 'First book of The Lord of the Rings.', 'https://covers.openlibrary.org/b/isbn/9780261103573-M.jpg', '9780261103573'),
('The Lion, the Witch and the Wardrobe', 14, 7, 1950, 'English', 'Chronicles of Narnia fantasy novel.', 'https://covers.openlibrary.org/b/isbn/9780064471046-M.jpg', '9780064471046'),
('The Immortals of Meluha', 15, 4, 2010, 'English', 'First book of the Shiva Trilogy.', 'https://m.media-amazon.com/images/S/compressed.photo.goodreads.com/books/1334659192i/7913305.jpg', '9780143425058'),
('The Hunger Games', 16, 5, 2008, 'English', 'Dystopian YA novel.', 'https://covers.openlibrary.org/b/isbn/9780439023528-M.jpg', '9780439023528'),
('Marvel Comics: Spider-Man', 18, 7, 1962, 'English', 'Classic Marvel superhero comics.', 'static/images/no_cover.png', '9780785198192'),
('The Common Man Cartoons', 19, 7, 1951, 'Marathi', 'Cartoon series by R.K. Laxman.', 'https://covers.openlibrary.org/b/isbn/9788172245177-M.jpg', '9788172245177'),
('Steve Jobs', 20, 7, 2011, 'English', 'Biography of Steve Jobs by Walter Isaacson.', 'https://covers.openlibrary.org/b/isbn/9781451648539-M.jpg', '9781451648539'),
('The History of Sikhs', 21, 7, 2003, 'English', 'Historical biography by Khushwant Singh.', 'static/images/no_cover.png', '9788171670448'),
('The Last Mughal', 22, 7, 2006, 'English', 'History of the last Mughal emperor.', 'https://m.media-amazon.com/images/S/compressed.photo.goodreads.com/books/1320556054i/124429.jpg', '9780143036002'),
('India: 1857', 23, 7, 2007, 'English', 'Historical account by Irfan Habib.', 'static/images/no_cover.png', '9780195678149'),
('Playing It My Way', 25, 7, 2014, 'English', 'Autobiography of Sachin Tendulkar.', 'static/images/no_cover.png', '9780349406429'),
('A Song of Ice and Fire: A Game of Thrones', 27, 2, 1996, 'English', 'First book of A Song of Ice and Fire.', 'https://covers.openlibrary.org/b/isbn/9780553103540-M.jpg', '9780553103540'),
('Twisted Love', 28, 3, 2021, 'English', 'First book in the Twisted romance series.', 'https://covers.openlibrary.org/b/isbn/9781728274867-M.jpg', '9781728274867');


INSERT INTO books (title, author_id, series_id, published_year, language, description, cover_image_url, isbn) VALUES
('It Ends with Us', 29, 7, 2016, 'English', 'Emotional romance novel.', 'https://covers.openlibrary.org/b/isbn/9781501110368-M.jpg', '9781501110368'),
('A Court of Thorns and Roses', 30, 8, 2015, 'English', 'Fantasy romance inspired by Beauty and the Beast.', 'https://covers.openlibrary.org/b/isbn/9781619634442-M.jpg', '9781619634442'),
('Mistborn: The Final Empire', 31, 9, 2006, 'English', 'Epic fantasy in the Cosmere universe.', 'https://covers.openlibrary.org/b/isbn/9780765311788-M.jpg', '9780765311788'),
('I Too Had a Love Story', 32, 7, 2008, 'English', 'Heartbreaking Indian romance.', 'https://books.google.com/books/content?id=04IlDD3rXjAC&printsec=frontcover&img=1&zoom=1&source=gbs_api', '9780143418761'),
('The Fault in Our Stars', 33, 7, 2012, 'English', 'YA romance about two teens with cancer.', 'https://covers.openlibrary.org/b/isbn/9780525478812-M.jpg', '9780525478812'),
('Divergent', 34, 11, 2011, 'English', 'YA dystopian novel.', 'https://covers.openlibrary.org/b/isbn/9780062024022-M.jpg', '9780062024022'),
('The Alchemist', 35, 7, 1988, 'English', 'Spiritual journey of Santiago.', 'https://covers.openlibrary.org/b/isbn/9780061122415-M.jpg', '9780061122415'),
('The Kite Runner', 36, 7, 2003, 'English', 'Story of friendship and redemption.', 'https://covers.openlibrary.org/b/isbn/9781594480003-M.jpg', '9781594480003'),
('Norwegian Wood', 37, 7, 1987, 'English', 'A nostalgic love story.', 'https://covers.openlibrary.org/b/isbn/9780375704024-M.jpg', '9780375704024'),
('The Blue Umbrella', 38, 7, 1980, 'English', 'Children''s novel set in the hills.', 'https://covers.openlibrary.org/b/isbn/9788171673421-M.jpg', '9788171673421'),
('Half Girlfriend', 39, 7, 2014, 'English', 'Romantic drama set in India.', 'https://covers.openlibrary.org/b/isbn/9788129135728-M.jpg', '9788129135728'),
('Percy Jackson: The Lightning Thief', 40, 10, 2005, 'English', 'Greek mythology adventure.', 'https://covers.openlibrary.org/b/id/14858779-L.jpg', '9780786838654'),
('The Seven Husbands of Evelyn Hugo', 41, 7, 2017, 'English', 'Fiction about a Hollywood icon.', 'https://ia800505.us.archive.org/view_archive.php?archive=/35/items/l_covers_0014/l_covers_0014_61.zip&file=0014611465-L.jpg', '9781501161933'),
('Me Before You', 42, 7, 2012, 'English', 'Romantic drama.', 'https://covers.openlibrary.org/b/isbn/9780718157838-M.jpg', '9780718157838'),
('The Forty Rules of Love', 43, 7, 2010, 'English', 'Sufi-inspired love story.', 'https://covers.openlibrary.org/b/isbn/9780241972939-M.jpg', '9780241972939');

INSERT INTO books (title, author_id, series_id, published_year, language, description, cover_image_url, isbn) VALUES
-- Classics & Literary Fiction
('And Then There Were None', 44, 7, 1939, 'English', 'The world’s best-selling mystery novel.', 'https://covers.openlibrary.org/b/isbn/9780062073488-M.jpg', '9780062073488'),
('Murder on the Orient Express', 44, 12, 1934, 'English', 'A famous mystery featuring Hercule Poirot.', 'https://covers.openlibrary.org/b/isbn/9780062073501-M.jpg', '9780062073501'),
('A Study in Scarlet', 45, 13, 1887, 'English', 'The first appearance of Sherlock Holmes.', 'https://books.google.com/books/content?id=xN2lK7oPTjYC&printsec=frontcover&img=1&zoom=1&source=gbs_api', '9780140053662'),
('1984', 46, 7, 1949, 'English', 'Dystopian social science fiction.', 'https://covers.openlibrary.org/b/isbn/9780451524935-M.jpg', '9780451524935'),
('Animal Farm', 46, 7, 1945, 'English', 'Political satire allegory.', 'https://covers.openlibrary.org/b/isbn/9780451526342-M.jpg', '9780451526342'),
('To Kill a Mockingbird', 47, 7, 1960, 'English', 'Classic novel about racial injustice.', 'https://covers.openlibrary.org/b/isbn/9780061120084-M.jpg', '9780061120084'),
('The Great Gatsby', 48, 7, 1925, 'English', 'A novel about the American dream.', 'https://covers.openlibrary.org/b/isbn/9780743273565-M.jpg', '9780743273565'),
('Crime and Punishment', 55, 7, 1866, 'English', 'Psychological anguish of a dilemma.', 'https://covers.openlibrary.org/b/isbn/9780140449136-M.jpg', '9780140449136'),
('One Hundred Years of Solitude', 56, 7, 1967, 'English', 'Magical realism saga of the Buendía family.', 'https://covers.openlibrary.org/b/isbn/9780060883287-M.jpg', '9780060883287'),

-- Indian Writing
('Wise and Otherwise', 49, 7, 2002, 'English', 'Collection of non-fiction stories.', 'https://covers.openlibrary.org/b/isbn/9780143062226-M.jpg', '9780143062226'),
('Dollar Bahu', 49, 7, 2005, 'English', 'Family drama about money and relationships.', 'https://books.google.com/books/content?id=WcYDAQAAQBAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', '9780143103765'),
('Wings of Fire', 50, 7, 1999, 'English', 'Autobiography of A.P.J. Abdul Kalam.', 'https://covers.openlibrary.org/b/isbn/9788173711466-M.jpg', '9788173711466'),
('The God of Small Things', 51, 7, 1997, 'English', 'Booker Prize winning novel about twins.', 'https://covers.openlibrary.org/b/isbn/9780679457312-M.jpg', '9780679457312'),
('2 States', 39, 7, 2009, 'English', 'Story about a marriage between two cultures.', 'https://covers.openlibrary.org/b/isbn/9788129115300-M.jpg', '9788129115300'),
('Five Point Someone', 39, 7, 2004, 'English', 'Three friends in IIT.', 'https://books.google.com/books/content?id=wd1qQgAACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', '9788129135490'),
('The 3 Mistakes of My Life', 39, 7, 2008, 'English', 'Friendship, cricket and politics.', 'https://covers.openlibrary.org/b/isbn/9788129135513-M.jpg', '9788129135513'),
('Train to Pakistan', 21, 7, 1956, 'English', 'Historical novel about the Partition of India.', 'https://ia801601.us.archive.org/view_archive.php?archive=/1/items/olcovers56/olcovers56-L.zip&file=568646-L.jpg', '9780143027758'),
('The Room on the Roof', 38, 7, 1956, 'English', 'Novel about an orphaned Anglo-Indian boy.', 'https://m.media-amazon.com/images/S/compressed.photo.goodreads.com/books/1398204015i/475235.jpg', '9780140103411');
INSERT INTO books (title, author_id, series_id, published_year, language, description, cover_image_url, isbn) VALUES
-- Fantasy & Sci-Fi
('Harry Potter and the Chamber of Secrets', 2, 1, 1998, 'English', 'Second book in the Harry Potter series.', 'https://covers.openlibrary.org/b/isbn/9780747538493-M.jpg', '9780747538493'),
('Harry Potter and the Prisoner of Azkaban', 2, 1, 1999, 'English', 'Third book in the Harry Potter series.', 'https://covers.openlibrary.org/b/isbn/9780747542155-M.jpg', '9780747542155'),
('Harry Potter and the Goblet of Fire', 2, 1, 2000, 'English', 'Fourth book in the Harry Potter series.', 'https://m.media-amazon.com/images/S/compressed.photo.goodreads.com/books/1627044952i/58613424.jpg', '9780747546245'),
('The Hobbit', 13, 6, 1937, 'English', 'Fantasy novel and prelude to LOTR.', 'https://covers.openlibrary.org/b/isbn/9780547928227-M.jpg', '9780547928227'),
('The Two Towers', 13, 6, 1954, 'English', 'Second volume of The Lord of the Rings.', 'https://covers.openlibrary.org/b/isbn/9780547928203-M.jpg', '9780547928203'),
('The Return of the King', 13, 6, 1955, 'English', 'Final volume of The Lord of the Rings.', 'https://covers.openlibrary.org/b/isbn/9780547928197-M.jpg', '9780547928197'),
('A Clash of Kings', 27, 2, 1998, 'English', 'Second novel in A Song of Ice and Fire.', 'https://covers.openlibrary.org/b/isbn/9780553108033-M.jpg', '9780553108033'),
('A Storm of Swords', 27, 2, 2000, 'English', 'Third novel in A Song of Ice and Fire.', 'https://covers.openlibrary.org/b/isbn/9780553106633-M.jpg', '9780553106633'),
('Dune', 52, 14, 1965, 'English', 'Epic sci-fi set on the desert planet Arrakis.', 'https://covers.openlibrary.org/b/isbn/9780441172719-M.jpg', '9780441172719'),
('The Sea of Monsters', 40, 10, 2006, 'English', 'Second book in Percy Jackson series.', 'https://books.google.com/books/content?id=gLPvoLN0meUC&printsec=frontcover&img=1&zoom=1&source=gbs_api', '9780786856863'),
('The Titan''s Curse', 40, 10, 2007, 'English', 'Third book in Percy Jackson series.', 'https://covers.openlibrary.org/b/isbn/9781423101451-M.jpg', '9781423101451'),
('Insurgent', 34, 11, 2012, 'English', 'Second book in Divergent series.', 'https://covers.openlibrary.org/b/isbn/9780062024046-M.jpg', '9780062024046'),
('Allegiant', 34, 11, 2013, 'English', 'Final book in Divergent series.', 'https://covers.openlibrary.org/b/isbn/9780062024060-M.jpg', '9780062024060'),
('Throne of Glass', 30, 7, 2012, 'English', 'Follows a teenage assassin.', 'https://covers.openlibrary.org/b/isbn/9781599906959-M.jpg', '9781599906959'),
('Crown of Midnight', 30, 7, 2013, 'English', 'Second book in Throne of Glass series.', 'https://covers.openlibrary.org/b/isbn/9781619630628-M.jpg', '9781619630628'),
('The Way of Kings', 31, 7, 2010, 'English', 'First book in The Stormlight Archive.', 'https://covers.openlibrary.org/b/isbn/9780765326355-M.jpg', '9780765326355'),

-- Thriller & Mystery
('Gone Girl', 53, 7, 2012, 'English', 'Thriller about a woman who disappears.', 'https://covers.openlibrary.org/b/isbn/9780307588364-M.jpg', '9780307588364'),
('The Silent Patient', 54, 7, 2019, 'English', 'Psychological thriller about a mute patient.', 'https://covers.openlibrary.org/b/isbn/9781250301697-M.jpg', '9781250301697'),
('Angels & Demons', 7, 7, 2000, 'English', 'Robert Langdon''s first adventure.', 'https://covers.openlibrary.org/b/isbn/9780671027353-M.jpg', '9780671027353'),
('Inferno', 7, 7, 2013, 'English', 'Robert Langdon solves a puzzle from Dante.', 'https://covers.openlibrary.org/b/isbn/9780385537858-M.jpg', '9780385537858'),
('The Shining', 11, 7, 1977, 'English', 'Horror novel set in the Overlook Hotel.', 'https://covers.openlibrary.org/b/isbn/9780385121675-M.jpg', '9780385121675'),
('Misery', 11, 7, 1987, 'English', 'Psychological horror about an obsessed fan.', 'https://covers.openlibrary.org/b/isbn/9780670813643-M.jpg', '9780670813643'),
('Pet Sematary', 11, 7, 1983, 'English', 'Horror novel about a burial ground.', 'https://covers.openlibrary.org/b/isbn/9780385182447-M.jpg', '9780385182447'),

-- Romance & Contemporary
('Verity', 29, 7, 2018, 'English', 'Dark romantic thriller.', 'https://covers.openlibrary.org/b/isbn/9781791392796-M.jpg', '9781791392796'),
('Ugly Love', 29, 7, 2014, 'English', 'A story about "friends with benefits".', 'https://covers.openlibrary.org/b/isbn/9781476753188-M.jpg', '9781476753188'),
('Reminders of Him', 29, 7, 2022, 'English', 'Second chance romance.', 'https://covers.openlibrary.org/b/isbn/9781542025607-M.jpg', '9781542025607'),
('Daisy Jones & The Six', 41, 7, 2019, 'English', 'Rise and fall of a rock band.', 'https://covers.openlibrary.org/b/isbn/9781524798628-M.jpg', '9781524798628'),
('Malibu Rising', 41, 7, 2021, 'English', 'Drama set in Malibu in 1983.', 'https://covers.openlibrary.org/b/isbn/9781524798659-M.jpg', '9781524798659'),
('Kafka on the Shore', 37, 7, 2002, 'English', 'Metaphysical novel by Murakami.', 'https://books.google.com/books/content?id=AfY51Um5FvcC&printsec=frontcover&img=1&zoom=1&source=gbs_api', '9781400043662'),

-- Non-Fiction
('Homo Deus', 4, 7, 2015, 'English', 'A Brief History of Tomorrow.', 'https://covers.openlibrary.org/b/isbn/9781910701874-M.jpg', '9781910701874'),
('21 Lessons for the 21st Century', 4, 7, 2018, 'English', 'Analysis of present day challenges.', 'https://covers.openlibrary.org/b/isbn/9780525512172-M.jpg', '9780525512172');
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
(1, 1),  -- Godaan → Fiction
(2, 3), (2, 11), (2, 12),  -- Harry Potter → Fantasy, YA, Children
(3, 1), (3, 18), -- Yayati → Fiction, Mythological
(4, 2), (4, 10), -- Sapiens → Non-fiction, History
(5, 2), (5, 10), -- India After Gandhi → Non-fiction, History
(6, 1), (6, 5), -- Pride & Prejudice → Fiction, Romance
(7, 1), (7, 6), (7, 7), -- Da Vinci Code → Fiction, Mystery, Thriller
(8, 1), (8, 6), -- Feluda Samagra → Fiction, Mystery
(9, 2), -- Shock of the New → Non-fiction
(10, 1), (10, 8), -- It → Fiction, Horror
(11, 1), -- Rashmirathi → Fiction
(12, 3), (12, 4), -- LOTR Fellowship → Fantasy, Epic Fantasy
(13, 3), (13, 11), -- Narnia → Fantasy, YA
(14, 3), (14, 18), -- Immortals of Meluha → Fantasy, Mythological
(15, 11), (15, 3), -- Hunger Games → YA, Fantasy
(16, 14), (16, 13), -- Spider-Man Comics → Comics, Graphic Novels
(17, 14), (17, 13), -- Common Man → Comics, Graphic Novels
(18, 9), (18, 2), -- Steve Jobs → Biography, Non-fiction
(19, 10), (19, 9), -- History of Sikhs → History, Biography
(20, 10), (20, 2), -- Last Mughal → History, Non-fiction
(21, 10), (21, 2), -- India 1857 → History, Non-fiction
(22, 9), (22, 2), -- Playing It My Way → Biography, Non-fiction
(23, 3), (23, 4), -- A Game of Thrones → Fantasy, Epic Fantasy
(24, 5);  -- Twisted Love → Romance

INSERT INTO book_genres (book_id, genre_id) VALUES
(25, 5), (25, 1), -- It Ends with Us → Romance, Fiction
(26, 3), (26, 5), -- ACOTAR → Fantasy, Romance
(27, 4), (27, 3), -- Mistborn → Epic Fantasy, Fantasy
(28, 5), (28, 1), -- I Too Had a Love Story → Romance, Fiction
(29, 11), (29, 5), -- TFIOS → YA, Romance
(30, 11), (30, 3), -- Divergent → YA, Fantasy
(31, 1), (31, 2), -- The Alchemist → Fiction, Non-fiction (philosophical)
(32, 1), (32, 5), -- The Kite Runner → Fiction, Drama
(33, 1), (33, 17), -- Norwegian Wood → Fiction, Surreal Fiction
(34, 12), (34, 1), -- Blue Umbrella → Children's, Fiction
(35, 5), (35, 1), -- Half Girlfriend → Romance, Fiction
(36, 3), (36, 11), -- PJO → Fantasy, YA
(37, 1), -- Evelyn Hugo → Fiction
(38, 5), (38, 1), -- Me Before You → Romance, Fiction
(39, 5), (39, 1), (39, 16); -- Forty Rules of Love → Romance, Fiction, Contemporary Fiction

-- Insert Genres IDs 40 - 88
INSERT INTO book_genres (book_id, genre_id) VALUES
-- Classics & Literary Fiction
(40, 6), (40, 7), -- And Then There Were None → Mystery, Thriller
(41, 6), (41, 1), -- Murder on the Orient Express → Mystery, Fiction
(42, 6), (42, 1), -- A Study in Scarlet → Mystery, Fiction
(43, 1), (43, 15), -- 1984 → Fiction, Contemporary (Dystopian fits best here given options)
(44, 1), -- Animal Farm → Fiction
(45, 1), (45, 10), -- To Kill a Mockingbird → Fiction, History
(46, 1), (46, 15), -- The Great Gatsby → Fiction, Contemporary
(47, 1), (47, 7), -- Crime and Punishment → Fiction, Thriller (Psychological)
(48, 1), (48, 17), -- One Hundred Years of Solitude → Fiction, Surreal Fiction

-- Indian Writing
(49, 2), -- Wise and Otherwise → Non-Fiction
(50, 1), (50, 15), -- Dollar Bahu → Fiction, Contemporary Fiction
(51, 9), (51, 2), -- Wings of Fire → Biography, Non-Fiction
(52, 1), (52, 15), -- The God of Small Things → Fiction, Contemporary Fiction
(53, 5), (53, 15), -- 2 States → Romance, Contemporary Fiction
(54, 1), (54, 15), -- Five Point Someone → Fiction, Contemporary Fiction
(55, 1), (55, 15), -- The 3 Mistakes of My Life → Fiction, Contemporary Fiction
(56, 10), (56, 1), -- Train to Pakistan → History, Fiction
(57, 1), (57, 12), -- The Room on the Roof → Fiction, Children's Fiction

-- Fantasy & Sci-Fi Sequels
(58, 3), (58, 11), -- HP Chamber of Secrets → Fantasy, YA
(59, 3), (59, 11), -- HP Prisoner of Azkaban → Fantasy, YA
(60, 3), (60, 11), -- HP Goblet of Fire → Fantasy, YA
(61, 3), (61, 4),  -- The Hobbit → Fantasy, Epic Fantasy
(62, 3), (62, 4),  -- The Two Towers → Fantasy, Epic Fantasy
(63, 3), (63, 4),  -- The Return of the King → Fantasy, Epic Fantasy
(64, 3), (64, 4),  -- A Clash of Kings → Fantasy, Epic Fantasy
(65, 3), (65, 4),  -- A Storm of Swords → Fantasy, Epic Fantasy
(66, 1), (66, 4),  -- Dune → Fiction, Epic Fantasy (Closest to Sci-Fi in list)
(67, 3), (67, 11), -- Sea of Monsters → Fantasy, YA
(68, 3), (68, 11), -- Titan's Curse → Fantasy, YA
(69, 11), (69, 1), -- Insurgent → YA, Fiction
(70, 11), (70, 1), -- Allegiant → YA, Fiction
(71, 3), (71, 11), -- Throne of Glass → Fantasy, YA
(72, 3), (72, 11), -- Crown of Midnight → Fantasy, YA
(73, 4), (73, 18), -- The Way of Kings → Epic Fantasy, High Fantasy

-- Thriller & Mystery
(74, 7), (74, 6), -- Gone Girl → Thriller, Mystery
(75, 7), (75, 6), -- The Silent Patient → Thriller, Mystery
(76, 7), (76, 6), -- Angels & Demons → Thriller, Mystery
(77, 7), (77, 6), -- Inferno → Thriller, Mystery
(78, 8), (78, 7), -- The Shining → Horror, Thriller
(79, 8), (79, 7), -- Misery → Horror, Thriller
(80, 8), (80, 1), -- Pet Sematary → Horror, Fiction

-- Romance & Contemporary
(81, 5), (81, 7), (81, 19), -- Verity → Romance, Thriller, Dark Romance
(82, 5), (82, 15), -- Ugly Love → Romance, Contemporary Fiction
(83, 5), (83, 15), -- Reminders of Him → Romance, Contemporary Fiction
(84, 1), (84, 15), -- Daisy Jones & The Six → Fiction, Contemporary Fiction
(85, 1), (85, 15), -- Malibu Rising → Fiction, Contemporary Fiction
(86, 17), (86, 1), -- Kafka on the Shore → Surreal Fiction, Fiction

-- Non-Fiction
(87, 2), (87, 10), -- Homo Deus → Non-Fiction, History
(88, 2), (88, 10); -- 21 Lessons... → Non-Fiction, History


-- drop table book_genres;

create table user_search_history (
  history_id int auto_increment primary key,
  user_id int,
  search_query varchar(255),
  -- book_id INT,  -- optional, if the query matched a book
  search_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(user_id)
  -- FOREIGN KEY (book_id) REFERENCES books(book_id)
);
select * from user_search_history;
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
