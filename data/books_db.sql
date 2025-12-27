-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3307
-- Generation Time: Dec 25, 2025 at 01:10 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `books_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `authors`
--
CREATE DATABASE books_db1;
USE books_db1;


CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `join_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `bio` text DEFAULT NULL,
  `about_me` text DEFAULT NULL,
  `gender` enum('Male','Female','Other') DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `profession` varchar(100) DEFAULT NULL,
  `profile_image_url` varchar(255) DEFAULT NULL,
  `role` enum('Admin','Reader') NOT NULL DEFAULT 'Reader'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--
insert into users(username,first_name,last_name,email,password_hash,join_date)values
('Netra321','Netra','patel','netrajigneshpateli@gmail.com','scrypt:32768:8:1$tQVT1oK7iMACd92W$e2962590852ca703af99fdb190c01c9da0a1e61fbd64e04d9d992837753fa9dbfe0e0af6f1384ac673985b5ec26e2413d9417224e607546a247b945d440d0051','2025-10-28 16:49:39');#Netra@321

insert into users(username,first_name,last_name,email,password_hash,join_date,role)values
('admin','abc','def','admin@gmail.com','$42d6bb0e669ad8eaffb3bb860a2ff6d20f9d450290529b116a2d1febbc62c119d8bd16213c3a1f48035f7759a3926acaf5a0a3b820fe80334866cda91cc4ba8d','2025-10-31 11:55:31','Admin');#Admin@123


INSERT INTO `users` (`user_id`, `username`, `first_name`, `last_name`, `email`, `password_hash`, `join_date`, `bio`, `about_me`, `gender`, `date_of_birth`, `profession`, `profile_image_url`, `role`) VALUES
(1, 'admin101', 'Administration', 'A', 'mruchita38@gmail.com', 'scrypt:32768:8:1$YS2iAcvhwiCf9J25$da6617fbf2cbe7663b68b59132001e858049ecda9f9962ebad96fb185014137bc218719e39e4cc03974a50e17d8753292fab9b43a066d1f70b150e3d39133c43', '2025-11-24 06:59:52', NULL, NULL, NULL, NULL, NULL, NULL, 'Admin'),
(2, 'ChauhanGautam04', 'Gautam', 'Chauhan', 'chauhangautam176@gmail.com', 'scrypt:32768:8:1$TfnjkExfrH8YUeBg$303f8192a2b5f3370a774970d8ad421be65b4ef1130430d705f947fc1eae501a4fdbb142c7315603a420f189b2b49ab1fbe447de11c336780557bd4214dc207b', '2025-11-24 07:01:56', 'Lover of soft romances, rainy days, and the smell of old books', 'Hi! I’m someone who finds comfort in fictional worlds, warm coffee, and slow mornings. I adore romance, light fantasy, and beautifully written stories that stay with you. Recommend me books that feel like a warm hug.', 'Male', '2005-07-23', 'Student', '\\static\\images\\gautam.png', 'Reader'),
(3, 'ruchita73', 'Ruchita', 'Mahale', 'ruchi04ta@gmail.com', 'scrypt:32768:8:1$NrUDHRgccfHbH2zE$f46363595203e9514efdd591d10b34204ff16337b622d8b9de5fd8d19438f8ddb87986706dccc316bbbbec472d285c8b870c9bcf5a8106563c9805b0a74084f1', '2025-11-24 07:24:12', 'In love with morally grey characters and twisted plots', 'I enjoy books that leave me thinking long after I finish them. Dark romance, thrillers, and mysteries are my escape. I love unpredictable endings, intense chemistry, and intricate storylines. The darker, the better.', 'Female', '2004-09-18', 'Student of Computer Science', '\\static\\images\\ruchita.jpg', 'Reader'),
(4, 'netra89', 'Netra', 'Patel', 'netrajigneshpatel@gmail.com', 'scrypt:32768:8:1$A6PaPuhCkvpX29dk$343be23cd92bd796bb0813c99d4af022bdc5d0a56dc8b811267e29e24e2c2d85db46512caa6564f43bf4eed51e783d5a502bad59407f5ddbb8196cec15acf9e8', '2025-11-24 07:25:42', 'Reader • Dreamer • Story Collector', 'I love reading romance, fiction, and thrillers. I enjoy emotional stories, character-driven plots, and books that make me feel something. Always looking for my next favourite read.', 'Female', NULL, NULL, '\\static\\images\\netra.jpeg', 'Reader'),
(5, 'keyuri75', 'Keyuri', 'Makwana', 'keyurimakwana75@gmail.com', 'scrypt:32768:8:1$s2XNWp6qmqZZ8MYc$e6c6cd72cb763e67b1d670bb57810968ddfe7fde075afa5666fe15b2e3dd8f0a22633f9c7a524c5c3a10a9c0022c5729bc0da6e79439d2f90616c32e22953913', '2025-11-24 07:26:43', 'NEW READER, LIVING IN DELUSION,', 'I AM A STUDENT WHO LOVES READING BOOKS IN FREE TIME.', 'Female', NULL, NULL, '\\static\\images\\keyuri.jpg', 'Reader'),
(6, 'aman59', 'Aman', 'Mistri', 'amanmistri45@gmail.com', 'scrypt:32768:8:1$fykCr3bibkWodbZh$2150ab3b7184c707889ac6cbecf95db3b8a87cc83ba1901e9c83fb9222fdd1eb84198cbcf78c48ba3310301bf903a515d3169c93b3bd8062f6544aac14ebfd7f', '2025-11-24 07:29:15', 'Hopeless romantic with a love for witty banter', 'I’m obsessed with fun, flirty rom-coms, messy characters, meet-cutes, and slow-burn chemistry. If it’s funny, sweet, and swoon-worthy, I’ll read it! Suggest me your cutest romance reads.', 'Male', NULL, NULL, '\\static\\images\\aman.jpeg', 'Reader'),
(7, 'JayP', 'Jay', 'Prajapati', 'jayprajapatirrr133@gmail.com', 'scrypt:32768:8:1$FXBNnXZxekMrc7Xz$5967d96c16b47723f2d407b1f22e6ea7f9c969ffa1239cdcffe6462b177b2d4ce67fa4fb10a3e9bb93de0ace4612ba52c27fae1e082d6b27e69b1bd06fd2cc58', '2025-11-24 07:30:54', 'Bookworm with a big heart and a bigger TBR.', 'Hi! I’m just someone who loves cosy reads, sweet romances, fun mysteries, and relatable characters. If the book can make me smile, cry, or scream — I want it! Let’s share recommendations.', 'Male', NULL, NULL, '\\static\\images\\jay.png', 'Reader'),
(8, 'deep72', 'Deep', 'Kotak', 'deepmkotak1103@gmail.com', 'scrypt:32768:8:1$7ExwwdhrJw4ss1Wk$6ed7636e5a337589b3e63f9136a97a3d4c32967a5125d97011b5a82f929ca027e2b1fb7846c61cdc6462a5905ae0d9b3b6083d8b4f7d4f81437b26b8734859fb', '2025-11-24 07:32:35', NULL, NULL, 'Male', NULL, NULL, NULL, 'Reader'),
(9, 'RhythmMahale', 'Rhythm', 'Mahale', 'rhythm758002@gmail.com', 'scrypt:32768:8:1$4WnmfhqFfOL8Qf5C$ea034e15bc39db95cdc7295cd429bf04744025e3db12eb8f5528be9d3e28192994b0fdd50679221ea5dc268535ac924a6d166394b6ba164377d63d0f81a9d894', '2025-11-24 07:35:43', 'Coffee-fueled mind living between pages', 'I adore dark academia, psychological thrillers, literary fiction, and beautifully poetic writing. I enjoy deep themes, flawed characters, and hauntingly memorable stories. Recommend me books that feel atmospheric and intense.', 'Male', NULL, NULL, '\\static\\images\\rhythm.png', 'Reader'),
(10, 'maitri63', 'Maitri', 'Bhalala', 'maitribhalala@gmail.com', 'scrypt:32768:8:1$zgyqbH6Tkl9PncC6$3030766c0d35d04fab3cad2d667d23505ba39bb0132319d3754cf2087a0f4608948a2969d2609a7d3b4d53acf51c2aea42fe195186b71dd9b0f722ca4d05d16b', '2025-11-24 07:38:07', 'I call myself Princess Eldora.', 'I love fantasy worlds, powerful heroines, dangerous villains, and romances that burn slowly but deeply.', 'Female', NULL, NULL, '\\static\\images\\maitri.jpeg', 'Reader'),
(11, 'rushang1999', 'Rushang', 'Mahale', 'rushangmahale1999@gmail.com', 'scrypt:32768:8:1$xupTaBG8KdZCxtvU$20a969a3443991c7ef24112ad3876a6319155f69d4eb0daac98d1cd14eb8f7816c2cbaa5cc06bc76443c43749f47dbbc1a386db1f6b80f9fced48aeaf92cc900', '2025-11-24 07:40:06', 'Becoming 1% better every day', 'I’m passionate about personal growth, self-improvement, and building healthy habits. I love books that challenge my mindset, help me evolve, and push me toward becoming my best self.', 'Male', NULL, NULL, NULL, 'Reader'),
(12, 'Maitri09', 'Maitri', 'Jhaveri', 'maitrijhaveri@gmail.com', 'scrypt:32768:8:1$50qc76LJfSbrcvXq$44b9a8253d28226b4a9bcbf415d93534045ef5d1f7efee6a62c5634edec2915c66374dda519976670f8fb54fbfe0171f69b27dbd1b1455813e121407e8124e42', '2025-11-24 10:25:54', 'Faculty at Department of Computer Science, Gujarat University', NULL, 'Female', NULL, 'Professor', NULL, 'Reader'),
(13, 'VaidehiVaghela', 'Vaidehi', 'Vaghela', 'vaidehi8@gmail.com', 'scrypt:32768:8:1$sn4iSpPMGw1PguCo$cd62aca0c8655539241b2fe32fd7086379a3703d82748a8c4aae1a090d84d570dd9860645468e835b4724ec2c2eb1ff76d5d0a4f0c99bcba321a103cbc07ac52', '2025-11-25 09:47:22', 'Faculty at Department of Computer Science, Gujarat University', 'Found my passion at reading', 'Female', NULL, 'Professor', NULL, 'Reader');


select * from users;

CREATE TABLE `authors` (
  `author_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `gender` enum('Male','Female','Other') DEFAULT NULL,
  `biography` text DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `password_hash` varchar(255) NOT NULL,
  `date_of_birth` date NOT NULL,
  `date_of_death` date DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `profile_image_url` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

ALTER TABLE authors
ADD COLUMN website VARCHAR(255) NULL;


--
-- Dumping data for table `authors`
--

INSERT INTO `authors` (`author_id`, `name`, `gender`, `biography`, `email`, `password_hash`, `date_of_birth`, `date_of_death`, `created_at`, `profile_image_url`) VALUES
(1, 'Premchand', 'Male', 'Pioneer of modern Hindi fiction, wrote social realism novels like Godaan.', NULL, '', '1880-07-31', '1936-10-08', '2025-12-23 17:50:40', ''),
(2, 'J.K. Rowling', 'Female', 'British author of the Harry Potter fantasy series.', 'ruchi04ta@gmail.com', '', '1965-07-31', NULL, '2025-12-23 17:50:40', ''),
(3, 'Vishnu Sakharam Khandekar', 'Male', 'Marathi novelist, first Marathi author to win Jnanpith Award.', NULL, '', '1898-01-11', '1976-09-02', '2025-12-23 17:50:40', ''),
(4, 'Yuval Noah Harari', 'Male', 'Israeli historian and author of Sapiens and Homo Deus.', 'netrajigneshpatel@gmail.com', '', '1976-02-24', NULL, '2025-12-23 17:50:40', ''),
(5, 'Ramachandra Guha', 'Male', 'Indian historian and biographer.', 'keyurimakwana7@gmail.com', '', '1958-04-29', NULL, '2025-12-23 17:50:40', ''),
(6, 'Jane Austen', 'Female', 'English author famous for Pride and Prejudice and other romance novels.', NULL, '', '1775-12-16', '1817-07-18', '2025-12-23 17:50:40', ''),
(7, 'Dan Brown', 'Male', 'American author of thriller novels like The Da Vinci Code.', 'dan_brown@gmail.com', '', '1964-06-22', NULL, '2025-12-23 17:50:40', ''),
(8, 'Satyajit Ray', 'Male', 'Indian filmmaker and author of thriller stories (Feluda series).', NULL, '', '1921-05-02', '1992-04-23', '2025-12-23 17:50:40', ''),
(9, 'Robert Hughes', 'Male', 'Art critic and author of The Shock of the New.', NULL, '', '1938-07-28', '2012-08-06', '2025-12-23 17:50:40', ''),
(10, 'Subodh Gupta', 'Male', 'Contemporary Indian artist and writer on modern Indian art.', 'subodh_gupta@gmail.com', '', '1964-11-04', NULL, '2025-12-23 17:50:40', ''),
(11, 'Stephen King', 'Male', 'American author of horror, supernatural fiction, and thrillers.', 'stephen_king@gmail.com', '', '1947-09-21', NULL, '2025-12-23 17:50:40', ''),
(12, 'Ramdhari Singh Dinkar', 'Male', 'Hindi poet and writer who explored darker themes.', NULL, '', '1908-09-23', '1974-04-24', '2025-12-23 17:50:40', ''),
(13, 'J.R.R. Tolkien', 'Male', 'British author of The Lord of the Rings and The Hobbit.', NULL, '', '1892-01-03', '1973-09-02', '2025-12-23 17:50:40', ''),
(14, 'C.S. Lewis', 'Male', 'British author of The Chronicles of Narnia series.', NULL, '', '1898-11-29', '1963-11-22', '2025-12-23 17:50:40', ''),
(15, 'Amish Tripathi', 'Male', 'Indian author known for the Shiva Trilogy, fantasy novels in English.', 'amish_tripathi@gmail.com', '', '1974-10-18', NULL, '2025-12-23 17:50:40', ''),
(16, 'Suzanne Collins', 'Female', 'American author of The Hunger Games series.', 'suzanne_collins@gmail.com', '', '1962-08-10', NULL, '2025-12-23 17:50:40', ''),
(17, 'Anuja Chauhan', 'Female', 'Indian novelist writing YA/fiction in English and Hindi.', 'anuja_chauhan@gmail.com', '', '1970-06-10', NULL, '2025-12-23 17:50:40', ''),
(18, 'Stan Lee', 'Male', 'American comic book writer, co-creator of Marvel superheroes.', NULL, '', '1922-12-28', '2018-11-12', '2025-12-23 17:50:40', ''),
(19, 'R.K. Laxman', 'Male', 'Indian cartoonist, creator of The Common Man.', NULL, '', '1921-10-24', '2015-01-26', '2025-12-23 17:50:40', ''),
(20, 'Walter Isaacson', 'Male', 'American author of biographies on Steve Jobs, Einstein, Leonardo da Vinci.', 'walter_isaacson@gmail.com', '', '1952-05-20', NULL, '2025-12-23 17:50:40', ''),
(21, 'Khushwant Singh', 'Male', 'Indian writer and biographer.', NULL, '', '1915-02-02', '2014-03-20', '2025-12-23 17:50:40', ''),
(22, 'William Dalrymple', 'Male', 'British historian and author of books on Indian history.', 'william_dalrymple@gmail.com', '', '1965-05-20', NULL, '2025-12-23 17:50:40', ''),
(23, 'Irfan Habib', 'Male', 'Indian historian specializing in medieval India.', 'irfan_habib@gmail.com', '', '1931-08-03', NULL, '2025-12-23 17:50:40', ''),
(24, 'Bipan Chandra', 'Male', 'Indian historian and author of modern Indian history books.', NULL, '', '1928-08-14', '2014-08-30', '2025-12-23 17:50:40', ''),
(25, 'Abhinav Bindra', 'Male', 'Indian Olympic gold medalist, author of autobiography.', 'abhinav_bindra@gmail.com', '', '1982-09-28', NULL, '2025-12-23 17:50:40', ''),
(26, 'Sachin Tendulkar', 'Male', 'Indian cricketer, author of autobiography and sports books.', 'sachin_tendulkar@gmail.com', '', '1973-04-24', NULL, '2025-12-23 17:50:40', ''),
(27, 'George R.R. Martin', 'Male', 'American author known for the A Song of Ice and Fire series.', 'george_martin@gmail.com', '', '1948-09-20', NULL, '2025-12-23 17:50:40', ''),
(28, 'Ana Huang', 'Female', 'Contemporary romance novelist, known for the Twisted series.', 'ana_huang@gmail.com', '', '0000-00-00', NULL, '2025-12-23 17:50:40', ''),
(29, 'Colleen Hoover', 'Female', 'American author of contemporary romance and emotional fiction.', 'colleen_hoover@gmail.com', '', '1979-12-11', NULL, '2025-12-23 17:50:40', ''),
(30, 'Sarah J. Maas', 'Female', 'American fantasy author, known for ACOTAR and TOG series.', 'sarah_maas@gmail.com', '', '1986-03-05', NULL, '2025-12-23 17:50:40', ''),
(31, 'Brandon Sanderson', 'Male', 'American epic fantasy author, Mistborn and Cosmere universe.', 'brandon_sanderson@gmail.com', '', '1975-12-19', NULL, '2025-12-23 17:50:40', ''),
(32, 'Ravinder Singh', 'Male', 'Indian romance author known for emotional love stories.', 'ravinder_singh@gmail.com', '', '1982-02-04', NULL, '2025-12-23 17:50:40', ''),
(33, 'John Green', 'Male', 'American author of YA novels like The Fault in Our Stars.', 'john_green@gmail.com', '', '1977-08-24', NULL, '2025-12-23 17:50:40', ''),
(34, 'Veronica Roth', 'Female', 'American YA author known for Divergent series.', 'veronica_roth@gmail.com', '', '1988-08-19', NULL, '2025-12-23 17:50:40', ''),
(35, 'Paulo Coelho', 'Male', 'Brazilian novelist known for The Alchemist.', 'paulo_coelho@gmail.com', '', '1947-08-24', NULL, '2025-12-23 17:50:40', ''),
(36, 'Khaled Hosseini', 'Male', 'Afghan-American novelist known for The Kite Runner.', 'khaled_hosseini@gmail.com', '', '1965-03-04', NULL, '2025-12-23 17:50:40', ''),
(37, 'Haruki Murakami', 'Male', 'Japanese author known for surreal fiction.', 'haruki_murami@gmail.com', '', '1949-01-12', NULL, '2025-12-23 17:50:40', ''),
(38, 'Ruskin Bond', 'Male', 'Indian author of children’s and fiction books.', 'ruskin_bond@gmail.com', '', '1934-05-19', NULL, '2025-12-23 17:50:40', ''),
(39, 'Chetan Bhagat', 'Male', 'Indian author of contemporary fiction.', 'chetan_bhagat@gmail.com', '', '1974-04-22', NULL, '2025-12-23 17:50:40', ''),
(40, 'Rick Riordan', 'Male', 'American author of Percy Jackson series.', 'rick_riordan@gmail.com', '', '1964-06-05', NULL, '2025-12-23 17:50:40', ''),
(41, 'Taylor Jenkins Reid', 'Female', 'American author known for celebrity-driven fiction.', 'taylor_reid@gmail.com', '', '1983-12-20', NULL, '2025-12-23 17:50:40', ''),
(42, 'Jojo Moyes', 'Female', 'British romance author.', 'jojo_moyes@gmail.com', '', '1969-08-04', NULL, '2025-12-23 17:50:40', ''),
(43, 'Elif Shafak', 'Female', 'Turkish-British novelist known for multicultural themes.', 'elif_shafak@gmail.com', '', '1971-10-25', NULL, '2025-12-23 17:50:40', ''),
(44, 'Agatha Christie', 'Female', 'British writer known for her 66 detective novels.', NULL, '', '1890-09-15', '1976-01-12', '2025-12-23 17:50:40', ''),
(45, 'Arthur Conan Doyle', 'Male', 'British writer, creator of Sherlock Holmes.', NULL, '', '1859-05-22', '1930-07-07', '2025-12-23 17:50:40', ''),
(46, 'George Orwell', 'Male', 'English novelist, essayist, journalist and critic.', NULL, '', '1903-06-25', '1950-01-21', '2025-12-23 17:50:40', ''),
(47, 'Harper Lee', 'Female', 'American novelist known for To Kill a Mockingbird.', NULL, '', '1926-04-28', '2016-02-19', '2025-12-23 17:50:40', ''),
(48, 'F. Scott Fitzgerald', 'Male', 'American novelist of the Jazz Age.', NULL, '', '1896-09-24', '1940-12-21', '2025-12-23 17:50:40', ''),
(49, 'Sudha Murty', 'Female', 'Indian educator, author and philanthropist.', 'sudha_murty@gmail.com', '', '1950-08-19', NULL, '2025-12-23 17:50:40', ''),
(50, 'A.P.J. Abdul Kalam', 'Male', 'Indian aerospace scientist and statesman.', NULL, '', '1931-10-15', '2015-07-27', '2025-12-23 17:50:40', ''),
(51, 'Arundhati Roy', 'Female', 'Indian author and political activist.', 'arundhati_roy@gmail.com', '', '1961-11-24', NULL, '2025-12-23 17:50:40', ''),
(52, 'Frank Herbert', 'Male', 'American science fiction author.', NULL, '', '1920-10-08', '1986-02-11', '2025-12-23 17:50:40', ''),
(53, 'Gillian Flynn', 'Female', 'American author known for thriller novels.', 'gillian_flynn@gmail.com', '', '1971-02-24', NULL, '2025-12-23 17:50:40', ''),
(54, 'Alex Michaelides', 'Male', 'Cypriot-American author of thrillers.', 'alex_michaelides@gmail.com', '', '1977-09-04', NULL, '2025-12-23 17:50:40', ''),
(55, 'Fyodor Dostoevsky', 'Male', 'Russian novelist and philosopher.', NULL, '', '1821-11-11', '1881-02-09', '2025-12-23 17:50:40', ''),
(56, 'Gabriel García Márquez', 'Male', 'Colombian novelist and Nobel laureate.', NULL, '', '1927-03-06', '2014-04-17', '2025-12-23 17:50:40', ''),
(57, 'Daniel Kahneman', 'Male', 'Daniel Kahneman was an Israeli-American psychologist and Nobel Prize winner (2002), known for his work on behavioral economics. He co-developed Prospect Theory and the concepts of heuristics and cognitive biases, which explain common decision-making errors. He was a professor emeritus of psychology at Princeton University.', '', '', '1934-03-05', '2024-03-27', '2025-12-24 21:52:25', 'https://images.squarespace-cdn.com/content/v1/5e9dffafb55f6258d0337a4b/1645805107374-C2GW98DESOO1R8SVBWGE/Daniel+Kahneman+Headshot.jpg'),
(58, 'C.G. Jung', 'Male', 'Carl Gustav Jung was a Swiss psychiatrist and psychotherapist who founded analytical psychology. He introduced influential concepts such as introversion and extraversion, archetypes, the collective unconscious, individuation, and synchronicity, and his ideas inspired tools like the Myers-Briggs Type Indicator (MBTI).\r\n\r\nWhile a practicing clinician, Jung also explored philosophy, religion, mythology, alchemy, and the arts. Though sometimes seen as a mystic, he viewed himself as a scientist. His work has had a lasting impact on psychology, spirituality, and modern thought.', NULL, '', '1875-07-26', '1961-06-06', '2025-12-24 21:52:25', 'https://www.jungiananalysts.org/img/jung.jpg'),
(59, 'Dale Carnegie', 'Male', 'Dale Carnegie was an American writer and teacher of courses in self-improvement, salesmanship, corporate training, public speaking, and interpersonal skills. Born into poverty on a farm in Missouri, he was the author of How to Win Friends and Influence People (1936), a bestseller that remains popular today. He also wrote How to Stop Worrying and Start Living (1948), Lincoln the Unknown (1932), and several other books.\r\nOne of the core ideas in his books is that it is possible to change other people\'s behavior by changing one\'s behavior towards them.', NULL, '', '1888-11-24', '1955-11-01', '2025-12-24 22:00:18', NULL),
(60, 'James Clear', 'Male', 'James Clear is the author of Atomic Habits, a bestselling guide to building good habits and breaking bad ones.\r\nHe writes about habits, decision-making, and continuous improvement at jamesclear.com, which attracts millions of readers and a large email audience.\r\nHis work has appeared in major publications like The New York Times and Time, and he regularly speaks to Fortune 500 companies and professional sports teams.', 'james_clear@gmail.com', '', '1986-01-01', NULL, '2025-12-24 22:00:18', NULL),
(63, 'Robin Sharma', 'Male', 'Robin Sharma is a Canadian author, leadership expert, and motivational speaker best known for The Monk Who Sold His Ferrari. A former lawyer, he left his legal career to focus on personal mastery, leadership, and self-improvement. His books have sold millions of copies worldwide, and he regularly speaks to global organizations and Fortune 500 companies on leadership and performance.', 'robin_sharma@gmail.com', '', '1964-06-16', NULL, '2025-12-24 22:08:39', 'https://images.gr-assets.com/authors/1245404621p8/24678.jpg'),
(64, 'Agatha Christie', 'Female', 'Agatha Christie was an English writer famed for 66 detective novels and 14 short story collections, featuring iconic characters like Hercule Poirot and Miss Marple. Known as the “Queen of Crime,” she also wrote The Mousetrap, the world’s longest-running play. Knighted in 1971, she is the best-selling fiction writer of all time, with over two billion copies sold.', NULL, '', '1890-09-15', '1976-01-12', '2025-12-24 22:08:39', 'https://images.gr-assets.com/authors/1589991473p8/123715.jpg'),
(65, 'Sanjeev Kapoor', 'Male', 'Sanjeev Kapoor is a renowned Indian chef, entrepreneur, and television personality best known for hosting the long-running cookery show Khana Khazana. He has played a major role in popularizing Indian cuisine globally through his cookbooks, restaurants, and media presence. Awarded the Padma Shri in 2017, Kapoor is one of the most influential and recognizable chefs in India.', 'sanjeev_kapoor@gmail.com', '', '1964-04-10', NULL, '2025-12-24 22:19:19', 'https://images.gr-assets.com/authors/1355456907p8/95058.jpg'),
(66, 'Tarla Dalal', 'Female', 'Tarla Dalal was a renowned Indian chef, cookbook author, and food writer who popularized vegetarian cooking in India and abroad. She authored over 170 cookbooks, many focusing on Indian, vegetarian, and health-conscious recipes, and founded the Tarla Dalal Cooking Academy. Honored with the Padma Shri in 2007, she remains one of India’s most influential culinary figures.', NULL, '', '1936-06-03', '2013-11-06', '2025-12-24 22:19:19', NULL),
(67, 'Paul Theroux', NULL, 'Paul Theroux is an American author and travel writer best known for books such as The Great Railway Bazaar. He has written extensively across genres, including travel writing, novels, essays, and short stories, and is regarded as one of the most influential modern travel writers.', 'paul_theroux@gmail.com', '', '1941-04-10', NULL, '2025-12-24 22:25:52', 'https://images.gr-assets.com/authors/1206717783p8/9599.jpg'),
(68, 'Peter F. Drucker', 'Male', NULL, NULL, '', '1909-11-19', '2005-11-11', '2025-12-24 22:25:52', 'https://images.gr-assets.com/authors/1318472244p8/12008.jpg');

-- --------------------------------------------------------
select * from authors;
--
-- Table structure for table `books`
--

CREATE TABLE `books` (
  `book_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `author_id` int(11) DEFAULT NULL,
  `series_id` int(11) DEFAULT NULL,
  `published_year` int(11) DEFAULT NULL,
  `language` enum('English','Hindi','Gujarati','Marathi') NOT NULL,
  `description` text DEFAULT NULL,
  `cover_image_url` varchar(255) DEFAULT NULL,
  `isbn` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `books`
--

INSERT INTO `books` (`book_id`, `title`, `author_id`, `series_id`, `published_year`, `language`, `description`, `cover_image_url`, `isbn`) VALUES
(1, 'Godaan', 1, 7, 1936, 'Hindi', 'Classic Hindi novel on rural India and social issues.', 'static/images/godaan.png', '9788171673135'),
(2, 'Harry Potter and the Philosopher\'s Stone', 2, 1, 1997, 'English', 'The first book in the Harry Potter series.', 'https://covers.openlibrary.org/b/isbn/9780747532699-M.jpg', '9780747532699'),
(3, 'Yayati', 3, 7, 1959, 'Marathi', 'Retelling of mythological story of Yayati.', 'static/images/yayati.png', '9788171824506'),
(4, 'Sapiens: A Brief History of Humankind', 4, 7, 2011, 'English', 'History and impact of Homo sapiens.', 'https://covers.openlibrary.org/b/isbn/9780099590088-M.jpg', '9780099590088'),
(5, 'India After Gandhi', 5, 7, 2007, 'English', 'History of India post-independence.', 'static/images/india_after_gandhi.png', '9780312421036'),
(6, 'Pride and Prejudice', 6, 7, 1813, 'English', 'Classic romance novel by Jane Austen.', 'https://covers.openlibrary.org/b/isbn/9780141439518-M.jpg', '9780141439518'),
(7, 'The Da Vinci Code', 7, 7, 2003, 'English', 'Mystery thriller about secret societies.', 'https://covers.openlibrary.org/b/isbn/9780385504201-M.jpg', '9780385504201'),
(8, 'Feluda Samagra', 8, 7, 1980, 'Hindi', 'Detective stories by Satyajit Ray.', 'https://ia601909.us.archive.org/view_archive.php?archive=/31/items/l_covers_0013/l_covers_0013_31.zip&file=0013314988-L.jpg', '9788172239565'),
(9, 'The Shock of the New', 9, 7, 1980, 'English', 'Critical analysis of modern art.', 'static/images/the_shock_of_the_new.png', '9780140095273'),
(10, 'It', 11, 7, 1986, 'English', 'Horror novel by Stephen King.', 'https://covers.openlibrary.org/b/isbn/9780670813025-M.jpg', '9780670813025'),
(11, 'Rashmirathi', 12, 7, 1952, 'Hindi', 'Epic Hindi poem with mythological themes.', 'static/images/rashmirathi.png', '9788171670035'),
(12, 'The Fellowship of the Ring', 13, 6, 1954, 'English', 'First book of The Lord of the Rings.', 'https://covers.openlibrary.org/b/isbn/9780261103573-M.jpg', '9780261103573'),
(13, 'The Lion, the Witch and the Wardrobe', 14, 7, 1950, 'English', 'Chronicles of Narnia fantasy novel.', 'https://covers.openlibrary.org/b/isbn/9780064471046-M.jpg', '9780064471046'),
(14, 'The Immortals of Meluha', 15, 4, 2010, 'English', 'First book of the Shiva Trilogy.', 'https://ia904605.us.archive.org/view_archive.php?archive=/14/items/l_covers_0011/l_covers_0011_15.zip&file=0011152324-L.jpg', '9780143425058'),
(15, 'The Hunger Games', 16, 5, 2008, 'English', 'Dystopian YA novel.', 'https://covers.openlibrary.org/b/isbn/9780439023528-M.jpg', '9780439023528'),
(16, 'Marvel Comics: Spider-Man', 18, 7, 1962, 'English', 'Classic Marvel superhero comics.', 'https://ia800800.us.archive.org/view_archive.php?archive=/27/items/olcovers66/olcovers66-L.zip&file=661367-L.jpg', '9780785198192'),
(17, 'The Common Man Cartoons', 19, 7, 1951, 'Marathi', 'Cartoon series by R.K. Laxman.', 'https://covers.openlibrary.org/b/isbn/9788172245177-M.jpg', '9788172245177'),
(18, 'Steve Jobs', 20, 7, 2011, 'English', 'Biography of Steve Jobs by Walter Isaacson.', 'https://covers.openlibrary.org/b/isbn/9781451648539-M.jpg', '9781451648539'),
(19, 'The History of Sikhs', 21, 7, 2003, 'English', 'Historical biography by Khushwant Singh.', 'https://ia600808.us.archive.org/view_archive.php?archive=/18/items/olcovers113/olcovers113-L.zip&file=1130146-L.jpg', '9788171670448'),
(20, 'The Last Mughal', 22, 7, 2006, 'English', 'History of the last Mughal emperor.', 'https://ia600100.us.archive.org/view_archive.php?archive=/5/items/l_covers_0012/l_covers_0012_46.zip&file=0012468017-L.jpg', '9780143036002'),
(21, 'Indian Economy under Early British Rule 1757–1857', 23, 7, 2016, 'English', 'Historical account by Irfan Habib.', 'https://ia601909.us.archive.org/view_archive.php?archive=/31/items/l_covers_0013/l_covers_0013_88.zip&file=0013885619-L.jpg', '9780195678149'),
(22, 'Playing It My Way', 26, 7, 2014, 'English', 'Autobiography of Sachin Tendulkar.', 'https://ia800404.us.archive.org/view_archive.php?archive=/33/items/l_covers_0010/l_covers_0010_40.zip&file=0010400033-L.jpg', '9780349406429'),
(23, 'A Song of Ice and Fire: A Game of Thrones', 27, 2, 1996, 'English', 'First book of A Song of Ice and Fire.', 'https://covers.openlibrary.org/b/isbn/9780553103540-M.jpg', '9780553103540'),
(24, 'Twisted Love', 28, 3, 2021, 'English', 'Alex Volkov is a cold, driven man haunted by a tragic past, focused only on success and vengeance—until he’s tasked with watching over his best friend’s sister, Ava Chen. She’s a bright, free-spirited woman trapped by childhood nightmares, yet she still sees the good beneath his icy exterior. What begins as duty becomes an intense, forbidden connection that cracks his walls and threatens to consume them both. As their opposites-attract chemistry grows, long-buried secrets surface, endangering their love and everything they care about. A brother’s-best-friend romance with suspenseful twists, explicit content, and a morally gray, possessive hero; can be read as a standalone.', 'https://covers.openlibrary.org/b/isbn/9781728274867-M.jpg', '9781728274867'),
(25, 'It Ends with Us', 29, 7, 2016, 'English', 'Emotional romance novel.', 'https://covers.openlibrary.org/b/isbn/9781501110368-M.jpg', '9781501110368'),
(26, 'A Court of Thorns and Roses', 30, 8, 2015, 'English', 'Fantasy romance inspired by Beauty and the Beast.', 'https://covers.openlibrary.org/b/isbn/9781619634442-M.jpg', '9781619634442'),
(27, 'Mistborn: The Final Empire', 31, 9, 2006, 'English', 'Epic fantasy in the Cosmere universe.', 'https://covers.openlibrary.org/b/isbn/9780765311788-M.jpg', '9780765311788'),
(28, 'I Too Had a Love Story', 32, 7, 2008, 'English', 'Heartbreaking Indian romance.', 'https://books.google.com/books/content?id=04IlDD3rXjAC&printsec=frontcover&img=1&zoom=1&source=gbs_api', '9780143418761'),
(29, 'The Fault in Our Stars', 33, 7, 2012, 'English', 'YA romance about two teens with cancer.', 'https://covers.openlibrary.org/b/isbn/9780525478812-M.jpg', '9780525478812'),
(30, 'Divergent', 34, 11, 2011, 'English', 'YA dystopian novel.', 'https://covers.openlibrary.org/b/isbn/9780062024022-M.jpg', '9780062024022'),
(31, 'The Alchemist', 35, 7, 1988, 'English', 'Spiritual journey of Santiago.', 'https://covers.openlibrary.org/b/isbn/9780061122415-M.jpg', '9780061122415'),
(32, 'The Kite Runner', 36, 7, 2003, 'English', 'Story of friendship and redemption.', 'https://covers.openlibrary.org/b/isbn/9781594480003-M.jpg', '9781594480003'),
(33, 'Norwegian Wood', 37, 7, 1987, 'English', 'A nostalgic love story.', 'https://covers.openlibrary.org/b/isbn/9780375704024-M.jpg', '9780375704024'),
(34, 'The Blue Umbrella', 38, 7, 1980, 'English', 'Children\'s novel set in the hills.', 'https://covers.openlibrary.org/b/isbn/9788171673421-M.jpg', '9788171673421'),
(35, 'Half Girlfriend', 39, 7, 2014, 'English', 'Romantic drama set in India.', 'https://covers.openlibrary.org/b/isbn/9788129135728-M.jpg', '9788129135728'),
(36, 'Percy Jackson: The Lightning Thief', 40, 10, 2005, 'English', 'Greek mythology adventure.', 'https://covers.openlibrary.org/b/id/14858779-L.jpg', '9780786838654'),
(37, 'The Seven Husbands of Evelyn Hugo', 41, 7, 2017, 'English', 'Fiction about a Hollywood icon.', 'https://ia800505.us.archive.org/view_archive.php?archive=/35/items/l_covers_0014/l_covers_0014_61.zip&file=0014611465-L.jpg', '9781501161933'),
(38, 'Me Before You', 42, 7, 2012, 'English', 'Romantic drama.', 'https://covers.openlibrary.org/b/isbn/9780718157838-M.jpg', '9780718157838'),
(39, 'The Forty Rules of Love', 43, 7, 2010, 'English', 'Sufi-inspired love story.', 'https://covers.openlibrary.org/b/isbn/9780241972939-M.jpg', '9780241972939'),
(40, 'And Then There Were None', 44, 7, 1939, 'English', 'The world’s best-selling mystery novel.', 'https://covers.openlibrary.org/b/isbn/9780062073488-M.jpg', '9780062073488'),
(41, 'Murder on the Orient Express', 44, 12, 1934, 'English', 'A famous mystery featuring Hercule Poirot.', 'https://covers.openlibrary.org/b/isbn/9780062073501-M.jpg', '9780062073501'),
(42, 'A Study in Scarlet', 45, 13, 1887, 'English', 'The first appearance of Sherlock Holmes.', 'https://books.google.com/books/content?id=xN2lK7oPTjYC&printsec=frontcover&img=1&zoom=1&source=gbs_api', '9780140053662'),
(43, '1984', 46, 7, 1949, 'English', 'Dystopian social science fiction.', 'https://covers.openlibrary.org/b/isbn/9780451524935-M.jpg', '9780451524935'),
(44, 'Animal Farm', 46, 7, 1945, 'English', 'Political satire allegory.', 'https://covers.openlibrary.org/b/isbn/9780451526342-M.jpg', '9780451526342'),
(45, 'To Kill a Mockingbird', 47, 7, 1960, 'English', 'Classic novel about racial injustice.', 'https://covers.openlibrary.org/b/isbn/9780061120084-M.jpg', '9780061120084'),
(46, 'The Great Gatsby', 48, 7, 1925, 'English', 'A novel about the American dream.', 'https://covers.openlibrary.org/b/isbn/9780743273565-M.jpg', '9780743273565'),
(47, 'Crime and Punishment', 55, 7, 1866, 'English', 'Psychological anguish of a dilemma.', 'https://covers.openlibrary.org/b/isbn/9780140449136-M.jpg', '9780140449136'),
(48, 'One Hundred Years of Solitude', 56, 7, 1967, 'English', 'Magical realism saga of the Buendía family.', 'https://covers.openlibrary.org/b/isbn/9780060883287-M.jpg', '9780060883287'),
(49, 'Wise and Otherwise', 49, 7, 2002, 'English', 'Collection of non-fiction stories.', 'https://covers.openlibrary.org/b/isbn/9780143062226-M.jpg', '9780143062226'),
(50, 'Dollar Bahu', 49, 7, 2005, 'English', 'Family drama about money and relationships.', 'https://books.google.com/books/content?id=WcYDAQAAQBAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', '9780143103765'),
(51, 'Wings of Fire', 50, 7, 1999, 'English', 'Autobiography of A.P.J. Abdul Kalam.', 'https://covers.openlibrary.org/b/isbn/9788173711466-M.jpg', '9788173711466'),
(52, 'The God of Small Things', 51, 7, 1997, 'English', 'Booker Prize winning novel about twins.', 'https://covers.openlibrary.org/b/isbn/9780679457312-M.jpg', '9780679457312'),
(53, '2 States', 39, 7, 2009, 'English', 'Story about a marriage between two cultures.', 'https://covers.openlibrary.org/b/isbn/9788129115300-M.jpg', '9788129115300'),
(54, 'Five Point Someone', 39, 7, 2004, 'English', 'Three friends in IIT.', 'https://books.google.com/books/content?id=wd1qQgAACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api', '9788129135490'),
(55, 'The 3 Mistakes of My Life', 39, 7, 2008, 'English', 'Friendship, cricket and politics.', 'https://covers.openlibrary.org/b/isbn/9788129135513-M.jpg', '9788129135513'),
(56, 'Train to Pakistan', 21, 7, 1956, 'English', 'Historical novel about the Partition of India.', 'https://ia801601.us.archive.org/view_archive.php?archive=/1/items/olcovers56/olcovers56-L.zip&file=568646-L.jpg', '9780143027758'),
(57, 'The Room on the Roof', 38, 7, 1956, 'English', 'Novel about an orphaned Anglo-Indian boy.', 'https://m.media-amazon.com/images/S/compressed.photo.goodreads.com/books/1398204015i/475235.jpg', '9780140103411'),
(58, 'Harry Potter and the Chamber of Secrets', 2, 1, 1998, 'English', 'Second book in the Harry Potter series.', 'https://covers.openlibrary.org/b/isbn/9780747538493-M.jpg', '9780747538493'),
(59, 'Harry Potter and the Prisoner of Azkaban', 2, 1, 1999, 'English', 'Third book in the Harry Potter series.', 'https://covers.openlibrary.org/b/isbn/9780747542155-M.jpg', '9780747542155'),
(60, 'Harry Potter and the Goblet of Fire', 2, 1, 2000, 'English', 'Fourth book in the Harry Potter series.', 'https://m.media-amazon.com/images/S/compressed.photo.goodreads.com/books/1627044952i/58613424.jpg', '9780747546245'),
(61, 'The Hobbit', 13, 6, 1937, 'English', 'Fantasy novel and prelude to LOTR.', 'https://covers.openlibrary.org/b/isbn/9780547928227-M.jpg', '9780547928227'),
(62, 'The Two Towers', 13, 6, 1954, 'English', 'Second volume of The Lord of the Rings.', 'https://covers.openlibrary.org/b/isbn/9780547928203-M.jpg', '9780547928203'),
(63, 'The Return of the King', 13, 6, 1955, 'English', 'Final volume of The Lord of the Rings.', 'https://covers.openlibrary.org/b/isbn/9780547928197-M.jpg', '9780547928197'),
(64, 'A Clash of Kings', 27, 2, 1998, 'English', 'Second novel in A Song of Ice and Fire.', 'https://covers.openlibrary.org/b/isbn/9780553108033-M.jpg', '9780553108033'),
(65, 'A Storm of Swords', 27, 2, 2000, 'English', 'Third novel in A Song of Ice and Fire.', 'https://covers.openlibrary.org/b/isbn/9780553106633-M.jpg', '9780553106633'),
(66, 'Dune', 52, 14, 1965, 'English', 'Epic sci-fi set on the desert planet Arrakis.', 'https://covers.openlibrary.org/b/isbn/9780441172719-M.jpg', '9780441172719'),
(67, 'The Sea of Monsters', 40, 10, 2006, 'English', 'Second book in Percy Jackson series.', 'https://books.google.com/books/content?id=gLPvoLN0meUC&printsec=frontcover&img=1&zoom=1&source=gbs_api', '9780786856863'),
(68, 'The Titan\'s Curse', 40, 10, 2007, 'English', 'Third book in Percy Jackson series.', 'https://covers.openlibrary.org/b/isbn/9781423101451-M.jpg', '9781423101451'),
(69, 'Insurgent', 34, 11, 2012, 'English', 'Second book in Divergent series.', 'https://covers.openlibrary.org/b/isbn/9780062024046-M.jpg', '9780062024046'),
(70, 'Allegiant', 34, 11, 2013, 'English', 'Final book in Divergent series.', 'https://covers.openlibrary.org/b/isbn/9780062024060-M.jpg', '9780062024060'),
(71, 'Throne of Glass', 30, 7, 2012, 'English', 'Follows a teenage assassin.', 'https://covers.openlibrary.org/b/isbn/9781599906959-M.jpg', '9781599906959'),
(72, 'Crown of Midnight', 30, 7, 2013, 'English', 'Second book in Throne of Glass series.', 'https://covers.openlibrary.org/b/isbn/9781619630628-M.jpg', '9781619630628'),
(73, 'The Way of Kings', 31, 7, 2010, 'English', 'First book in The Stormlight Archive.', 'https://covers.openlibrary.org/b/isbn/9780765326355-M.jpg', '9780765326355'),
(74, 'Gone Girl', 53, 7, 2012, 'English', 'Thriller about a woman who disappears.', 'https://covers.openlibrary.org/b/isbn/9780307588364-M.jpg', '9780307588364'),
(75, 'The Silent Patient', 54, 7, 2019, 'English', 'Psychological thriller about a mute patient.', 'https://covers.openlibrary.org/b/isbn/9781250301697-M.jpg', '9781250301697'),
(76, 'Angels & Demons', 7, 7, 2000, 'English', 'Robert Langdon\'s first adventure.', 'https://covers.openlibrary.org/b/isbn/9780671027353-M.jpg', '9780671027353'),
(77, 'Inferno', 7, 7, 2013, 'English', 'Robert Langdon solves a puzzle from Dante.', 'https://covers.openlibrary.org/b/isbn/9780385537858-M.jpg', '9780385537858'),
(78, 'The Shining', 11, 7, 1977, 'English', 'Horror novel set in the Overlook Hotel.', 'https://covers.openlibrary.org/b/isbn/9780385121675-M.jpg', '9780385121675'),
(79, 'Misery', 11, 7, 1987, 'English', 'Psychological horror about an obsessed fan.', 'https://covers.openlibrary.org/b/isbn/9780670813643-M.jpg', '9780670813643'),
(80, 'Pet Sematary', 11, 7, 1983, 'English', 'Horror novel about a burial ground.', 'https://covers.openlibrary.org/b/isbn/9780385182447-M.jpg', '9780385182447'),
(81, 'Verity', 29, 7, 2018, 'English', 'Dark romantic thriller.', 'https://covers.openlibrary.org/b/isbn/9781791392796-M.jpg', '9781791392796'),
(82, 'Ugly Love', 29, 7, 2014, 'English', 'A story about \"friends with benefits\".', 'https://covers.openlibrary.org/b/isbn/9781476753188-M.jpg', '9781476753188'),
(83, 'Reminders of Him', 29, 7, 2022, 'English', 'Second chance romance.', 'https://covers.openlibrary.org/b/isbn/9781542025607-M.jpg', '9781542025607'),
(84, 'Daisy Jones & The Six', 41, 7, 2019, 'English', 'Rise and fall of a rock band.', 'https://covers.openlibrary.org/b/isbn/9781524798628-M.jpg', '9781524798628'),
(85, 'Malibu Rising', 41, 7, 2021, 'English', 'Drama set in Malibu in 1983.', 'https://covers.openlibrary.org/b/isbn/9781524798659-M.jpg', '9781524798659'),
(86, 'Kafka on the Shore', 37, 7, 2002, 'English', 'Metaphysical novel by Murakami.', 'https://books.google.com/books/content?id=AfY51Um5FvcC&printsec=frontcover&img=1&zoom=1&source=gbs_api', '9781400043662'),
(87, 'Homo Deus', 4, 7, 2015, 'English', 'A Brief History of Tomorrow.', 'https://covers.openlibrary.org/b/isbn/9781910701874-M.jpg', '9781910701874'),
(88, '21 Lessons for the 21st Century', 4, 7, 2018, 'English', 'Analysis of present day challenges.', 'https://covers.openlibrary.org/b/isbn/9780525512172-M.jpg', '9780525512172'),
(89, 'Twisted Games', 28, 3, 2021, 'English', 'Rhys Larsen is a strict, emotionally detached bodyguard—until Princess Bridget shatters his rules. She’s stubborn, fiery, and forbidden, but he wants her anyway. Bridget, bound by duty and facing a political marriage she doesn’t want, falls for the one man she can’t have: her protector. Their dangerous, forbidden attraction threatens the throne and their futures. A slow-to-medium burn royal bodyguard romance that can be read as a standalone, with a possessive alpha hero, explicit content, and strong language.', 'https://ia800100.us.archive.org/view_archive.php?archive=/5/items/l_covers_0012/l_covers_0012_82.zip&file=0012821461-L.jpg', '9781735056661'),
(90, 'Twisted Hate', 28, 3, 2022, 'English', 'Josh Chen, a charming soon-to-be doctor, hates Jules Ambrose almost as much as he wants her. She’s the one woman immune to his charm, yet the one he can’t stop thinking about. After one explosive night, they agree to an enemies-with-benefits deal—no jealousy, no strings, no falling in love. Jules, a determined ex–party girl studying for the bar exam, wants nothing to do with the infuriating doctor…until she starts seeing the vulnerable side beneath his arrogance. He’s her best friend’s brother, her longtime nemesis, and the only person she shouldn’t want. As past demons resurface, their fiery connection threatens to save them—or break them. A steamy enemies-to-lovers romance that can be read as a standalone, with explicit content and mature themes.', 'https://covers.openlibrary.org/b/id/15088612-L.jpg', '9786073908634'),
(91, 'Twisted Lies', 28, 3, 2022, 'English', 'Christian Harper is a charming, ruthless man who hides his darkness behind tailored suits, and he’ll do anything to have the one woman he can’t stop wanting—Stella Alonso. She’s sweet, introverted, famous online, and the only person who stirs something real in him. When danger from her past forces her into his world, he breaks his rules and offers a deal she can’t refuse. What starts as fake dating becomes obsession, desire, and a bond built on secrets and lies. As truths surface, their twisted, addictive love risks falling apart. A steamy slow-to-medium burn romance that can be read as a standalone, with a morally gray hero, explicit content, violence, and sensitive themes.', 'https://covers.openlibrary.org/b/id/15144107-L.jpg', '9781728274898'),
(92, 'Slammed', 29, 18, 2012, 'English', 'Layken and Will fall for each other, only to discover a secret that forces them apart, pushing them to face grief, responsibility, and forbidden love.', 'https://ia600100.us.archive.org/view_archive.php?archive=/5/items/l_covers_0012/l_covers_0012_66.zip&file=0012661471-L.jpg', '9781468161663'),
(93, 'Point of Retreat', 29, 18, 2012, 'English', 'Layken and Will struggle to hold onto their relationship as new challenges, misunderstandings, and family struggles test their commitment.', 'https://covers.openlibrary.org/b/id/7614159-L.jpg', '9781476715926'),
(94, 'This Girl', 29, 18, 2013, 'English', 'Will retells their love story from his perspective, revealing hidden moments, deeper feelings, and the truth behind everything they faced.', 'https://ia800505.us.archive.org/view_archive.php?archive=/35/items/l_covers_0014/l_covers_0014_32.zip&file=0014328438-L.jpg', '9781476746531'),
(95, 'Hopeless', 29, 19, 2012, 'English', 'Sky’s world unravels when she meets Holder, a boy with answers to a past she can’t remember, leading to shocking revelations and emotional healing.', 'https://ia600404.us.archive.org/view_archive.php?archive=/33/items/l_covers_0010/l_covers_0010_54.zip&file=0010549926-L.jpg', '9781471133435'),
(96, 'A Shot At History: My Obsessive Journey to Olympic Gold', 25, 7, 2013, 'English', 'A Shot at History chronicles Abhinav Bindra’s journey to becoming India’s first individual Olympic gold medalist. After a heartbreaking loss at the 2004 Athens Olympics, Bindra reinvented himself through relentless discipline, science, and mental training to achieve gold at the 2008 Beijing Olympics. The book is a powerful story of perseverance, innovation, and the pursuit of excellence, capturing the challenges of winning, losing, and striving to be better again.', 'https://www.jainbookagency.com/bookimages/zip/141715.jpg', '9789350291122'),
(97, 'Thinking, Fast and Slow', 57, 7, 2011, 'English', 'Thinking, Fast and Slow explores how the mind works through two systems: System 1, which is fast and intuitive, and System 2, which is slow and logical. Daniel Kahneman reveals how cognitive biases like overconfidence and loss aversion shape our decisions in work and daily life. The book shows when to trust intuition, when to think more carefully, and how understanding both systems can improve judgment and decision-making.', 'https://imgv2-2-f.scribdassets.com/img/word_document/182569769/original/216x287/fb2c0855e3/1764652337?v=1', '9780374275631'),
(98, 'Man and His Symbols', 58, 7, 1968, 'English', 'Man and His Symbols owes its existence to one of Jung\'s own dreams. The great psychologist dreamed that his work was understood by a wide public, rather than just by psychiatrists, and therefore he agreed to write and edit this fascinating book. Here, Jung examines the full world of the unconscious, whose language he believed to be the symbols constantly revealed in dreams. Convinced that dreams offer practical advice, sent from the unconscious to the conscious self, Jung felt that self-understanding would lead to a full and productive life. Thus, the reader will gain new insights into himself from this thoughtful volume, which also illustrates symbols throughout history. Completed just before his death by Jung and his associates, it is clearly addressed to the general reader.', 'https://m.media-amazon.com/images/I/61MmBj3XHML.jpg', '9780440351832'),
(99, 'How to Win Friends and Influence People', 59, 7, 1998, 'English', 'How to Win Friends and Influence People is a timeless classic that shows how to succeed by improving relationships and communication. First published in 1936, it has sold over 30 million copies and helped countless people achieve success in business and life. The book teaches practical principles for making people like you, winning others to your way of thinking, and influencing change without conflict.', 'https://covers.openlibrary.org/b/id/15130876-L.jpg', '9788183227896'),
(100, 'Atomic Habits: An Easy & Proven Way to Build Good Habits & Break Bad Ones', 60, 7, 2018, 'English', 'Atomic Habits by James Clear explains how small, consistent changes can lead to remarkable results over time. The book focuses on building good habits, breaking bad ones, and mastering the systems behind behavior rather than relying on motivation alone. Using practical strategies and real-life examples, it shows how tiny improvements—“atomic habits”—can transform personal and professional life.', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT-8SrFOsOtv4aBArFUoZyh50Tq-n7F0dIW-w&s', '9780735211308'),
(101, 'The Monk Who Sold His Ferrari: A Fable About Fulfilling Your Dreams and Reaching Your Destiny', 63, 7, 1996, 'English', 'This inspiring tale provides a step-by-step approach to living with greater courage, balance, abundance, and joy. A wonderfully crafted fable, The Monk Who Sold His Ferrari tells the extraordinary story of Julian Mantle, a lawyer forced to confront the spiritual crisis of his out-of-balance life. On a life-changing odyssey to an ancient culture, he discovers powerful, wise, and practical lessons that teach us to: \r\n\r\nDevelop Joyful Thoughts, Follow Our Life\'s Mission and Calling, Cultivate Self-Discipline and Act Courageously, Value Time as Our Most Important Commodity, Nourish Our Relationships, and Live Fully, One Day at a Time.\r\n', 'https://ia800507.us.archive.org/view_archive.php?archive=/8/items/l_covers_0009/l_covers_0009_78.zip&file=0009785304-L.jpg', '9780062515674 ');


select * from books;
-- --------------------------------------------------------

--
-- Table structure for table `book_genres`
--

CREATE TABLE `book_genres` (
  `book_id` int(11) NOT NULL,
  `genre_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `book_genres`
--

INSERT INTO `book_genres` (`book_id`, `genre_id`) VALUES
(1, 1),
(2, 3),
(2, 11),
(2, 12),
(3, 1),
(3, 18),
(4, 2),
(4, 10),
(5, 2),
(5, 10),
(6, 1),
(6, 5),
(6, 30),
(7, 1),
(7, 6),
(7, 7),
(8, 1),
(8, 6),
(9, 2),
(9, 10),
(9, 27),
(10, 1),
(10, 8),
(11, 1),
(12, 3),
(12, 4),
(13, 3),
(13, 11),
(14, 3),
(14, 18),
(15, 3),
(15, 11),
(16, 13),
(16, 14),
(17, 13),
(17, 14),
(18, 2),
(18, 9),
(19, 9),
(19, 10),
(20, 2),
(20, 10),
(21, 2),
(21, 10),
(22, 2),
(22, 9),
(22, 61),
(22, 62),
(23, 3),
(23, 4),
(24, 1),
(24, 5),
(24, 19),
(24, 45),
(24, 49),
(25, 1),
(25, 5),
(26, 3),
(26, 5),
(27, 3),
(27, 4),
(28, 1),
(28, 5),
(29, 5),
(29, 11),
(30, 3),
(30, 11),
(31, 1),
(31, 2),
(32, 1),
(32, 5),
(33, 1),
(33, 17),
(34, 1),
(34, 12),
(35, 1),
(35, 5),
(36, 3),
(36, 11),
(37, 1),
(38, 1),
(38, 5),
(39, 1),
(39, 5),
(39, 16),
(40, 6),
(40, 7),
(41, 1),
(41, 6),
(42, 1),
(42, 6),
(43, 1),
(43, 15),
(44, 1),
(45, 1),
(45, 10),
(46, 1),
(46, 15),
(47, 1),
(47, 7),
(48, 1),
(48, 17),
(49, 2),
(50, 1),
(50, 15),
(51, 2),
(51, 9),
(52, 1),
(52, 15),
(53, 5),
(53, 15),
(54, 1),
(54, 15),
(55, 1),
(55, 15),
(56, 1),
(56, 10),
(57, 1),
(57, 12),
(58, 3),
(58, 11),
(59, 3),
(59, 11),
(60, 3),
(60, 11),
(61, 3),
(61, 4),
(62, 3),
(62, 4),
(63, 3),
(63, 4),
(64, 3),
(64, 4),
(65, 3),
(65, 4),
(66, 1),
(66, 4),
(67, 3),
(67, 11),
(68, 3),
(68, 11),
(69, 1),
(69, 11),
(70, 1),
(70, 11),
(71, 3),
(71, 11),
(72, 3),
(72, 11),
(73, 4),
(73, 18),
(74, 6),
(74, 7),
(74, 24),
(75, 6),
(75, 7),
(75, 24),
(76, 6),
(76, 7),
(77, 6),
(77, 7),
(78, 7),
(78, 8),
(78, 25),
(79, 7),
(79, 8),
(80, 1),
(80, 8),
(81, 5),
(81, 7),
(81, 19),
(82, 5),
(82, 15),
(83, 5),
(83, 15),
(84, 1),
(84, 15),
(85, 1),
(85, 15),
(86, 1),
(86, 17),
(87, 2),
(87, 10),
(88, 2),
(88, 10),
(89, 5),
(89, 19),
(89, 39),
(89, 40),
(89, 46),
(90, 1),
(90, 5),
(90, 19),
(90, 38),
(90, 40),
(90, 45),
(91, 1),
(91, 5),
(91, 19),
(91, 39),
(91, 46),
(91, 47),
(91, 48),
(92, 1),
(92, 5),
(92, 11),
(92, 40),
(92, 41),
(92, 42),
(93, 1),
(93, 5),
(93, 11),
(93, 15),
(94, 1),
(94, 5),
(94, 11),
(94, 15),
(95, 1),
(95, 5),
(95, 11),
(95, 15),
(96, 2),
(96, 9),
(96, 21),
(96, 36),
(96, 61),
(96, 62),
(97, 2),
(97, 20),
(97, 21),
(97, 22),
(98, 2),
(98, 20),
(98, 27),
(98, 30),
(99, 2),
(99, 20),
(99, 21),
(99, 22),
(99, 52),
(101, 2),
(101, 20),
(101, 21),
(101, 22),
(101, 29);

-- --------------------------------------------------------

--
-- Table structure for table `follows`
--

CREATE TABLE `follows` (
  `follow_id` int(11) NOT NULL,
  `follower_id` int(11) NOT NULL,
  `following_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `friend_requests`
--

CREATE TABLE `friend_requests` (
  `request_id` int(11) NOT NULL,
  `requester_id` int(11) NOT NULL,
  `requestee_id` int(11) NOT NULL,
  `status` enum('pending','accepted','rejected') DEFAULT 'pending',
  `requested_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `responded_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `friend_requests`
--

INSERT INTO `friend_requests` (`request_id`, `requester_id`, `requestee_id`, `status`, `requested_at`, `responded_at`) VALUES
(1, 2, 6, 'accepted', '2025-11-24 10:13:53', '2025-11-24 10:15:38'),
(2, 12, 5, 'rejected', '2025-11-24 10:27:20', '2025-11-24 10:30:12'),
(7, 5, 3, 'accepted', '2025-11-24 11:54:10', '2025-11-24 12:01:41'),
(8, 3, 11, 'accepted', '2025-11-24 18:19:52', '2025-11-25 07:31:05'),
(9, 2, 7, 'accepted', '2025-11-25 06:56:38', '2025-11-25 07:10:00'),
(10, 2, 3, 'pending', '2025-11-25 06:57:00', NULL),
(11, 5, 2, 'accepted', '2025-11-25 07:04:07', '2025-11-25 09:41:15'),
(12, 9, 3, 'pending', '2025-11-25 07:16:29', NULL),
(13, 9, 11, 'accepted', '2025-11-25 07:16:31', '2025-11-25 07:29:12'),
(14, 9, 12, 'pending', '2025-11-25 07:16:36', NULL),
(15, 6, 4, 'pending', '2025-11-25 07:18:40', NULL),
(16, 6, 9, 'pending', '2025-11-25 07:18:44', NULL),
(17, 10, 4, 'pending', '2025-11-25 07:27:32', NULL),
(18, 2, 8, 'pending', '2025-11-25 09:41:08', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `genres`
--

CREATE TABLE `genres` (
  `genre_id` int(11) NOT NULL,
  `genre_name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `genres`
--

INSERT INTO `genres` (`genre_id`, `genre_name`) VALUES
(27, 'Art'),
(61, 'Autobiography'),
(48, 'Billionaire Romance'),
(9, 'Biography'),
(54, 'Brand Management'),
(29, 'Business'),
(41, 'Chick Lit'),
(12, 'Children’s Fiction'),
(30, 'Classics'),
(14, 'Comics'),
(57, 'Computer Science'),
(39, 'Contemporary'),
(15, 'Contemporary Fiction'),
(40, 'Contemporary Romance'),
(26, 'Cookbooks'),
(23, 'Crime Thriller'),
(19, 'Dark Romance'),
(60, 'Data Science'),
(59, 'Database Systems'),
(45, 'Enemies to Lovers'),
(51, 'Entrepreneurship'),
(4, 'Epic Fantasy'),
(47, 'Fake Dating'),
(3, 'Fantasy'),
(1, 'Fiction'),
(46, 'Forced Proximity'),
(13, 'Graphic Novels'),
(56, 'Growth Marketing'),
(18, 'High Fantasy'),
(42, 'High School'),
(10, 'History'),
(8, 'Horror'),
(31, 'Humour and Comedy'),
(52, 'Leadership'),
(49, 'Love'),
(50, 'Management'),
(32, 'Manga'),
(53, 'Marketing'),
(36, 'Memoir'),
(33, 'Music'),
(6, 'Mystery'),
(16, 'Mythological Fiction'),
(38, 'New Adult'),
(2, 'Non-Fiction'),
(34, 'Paranormal'),
(25, 'Paranormal Horror'),
(22, 'Personal Development'),
(58, 'Programming'),
(24, 'Psychological Thriller'),
(20, 'Psychology'),
(35, 'Religion'),
(5, 'Romance'),
(55, 'Sales & Negotiation'),
(21, 'Self Help'),
(62, 'Sports'),
(17, 'Surreal Fiction'),
(7, 'Thriller'),
(28, 'Travel'),
(11, 'Young Adult');

-- --------------------------------------------------------

--
-- Table structure for table `reviews`
--

CREATE TABLE `reviews` (
  `review_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `book_id` int(11) DEFAULT NULL,
  `ratings` int(1) NOT NULL,
  `review_text` text DEFAULT NULL,
  `review_date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `reviews`
--

INSERT INTO `reviews` (`review_id`, `user_id`, `book_id`, `ratings`, `review_text`, `review_date`) VALUES
(1, 3, 53, 5, 'nice', '2025-11-24 08:42:52'),
(2, 4, 53, 3, 'It was a nice book but not my type', '2025-11-24 08:53:03'),
(4, 5, 53, 4, NULL, '2025-11-24 08:53:50'),
(5, 2, 53, 5, 'it was nice book', '2025-11-24 08:56:59'),
(6, 2, 7, 4, 'One of the amazing books I have read', '2025-11-24 09:03:52'),
(7, 6, 53, 4, NULL, '2025-11-24 10:19:52'),
(8, 6, 58, 3, 'too much of fantasy...far from reality', '2025-11-24 10:22:08'),
(9, 3, 10, 5, 'OMG!!! It\'s one of the best horror books i have \"ever\" read....I suggest everyone to try this one if you loovvveeeeee horror', '2025-11-24 17:57:01'),
(10, 2, 5, 4, NULL, '2025-11-25 06:53:01'),
(11, 2, 26, 5, 'Felt Goosebumps!!!', '2025-11-25 06:53:50'),
(12, 2, 4, 4, 'Currently reading Sapiens by Yuval Noah Harari, and wow, it’s already blowing my mind.\r\nHarari’s way of explaining human evolution, belief systems, and how societies formed is so clear and fascinating.\r\nWill update once I finish!', '2025-11-25 06:55:52'),
(13, 7, 56, 3, 'A poignant story set during Partition, but the emotional connection felt a bit limited for me.\r\nKhushwant Singh captures the chaos and brutality of the time very realistically, and the setting is incredibly vivid.\r\nHowever, I couldn’t fully connect with the characters, and some parts felt slow.\r\nA good, important read — just not a personal favourite.', '2025-11-25 07:11:08'),
(16, 9, 82, 5, NULL, '2025-11-25 07:17:00'),
(17, 10, 90, 5, 'oo god!!! the chase.....', '2025-11-25 07:25:21'),
(18, 10, 91, 5, 'I need my Christian Harper so badddd.......', '2025-11-25 07:26:46'),
(19, 11, 18, 2, 'Finished Steve Jobs.\r\nWell-researched but too long and too dry for me.\r\nI struggled to stay engaged, and the narration felt repetitive at times.\r\nA 2-star read.', '2025-11-25 07:30:41');

-- --------------------------------------------------------

--
-- Table structure for table `series`
--

CREATE TABLE `series` (
  `series_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `series`
--

INSERT INTO `series` (`series_id`, `name`, `description`) VALUES
(1, 'Harry Potter', 'Fantasy series about a young wizard and his adventures at Hogwarts.'),
(2, 'Game of Thrones', 'Epic fantasy series set in the Seven Kingdoms of Westeros.'),
(3, 'Twisted', 'Contemporary romance series by Ana Huang.'),
(4, 'Shiva Trilogy', 'Indian mythological fantasy series about Lord Shiva.'),
(5, 'The Hunger Games', 'Dystopian young adult series set in Panem.'),
(6, 'The Lord of the Rings', 'Epic high-fantasy trilogy.'),
(7, 'Standalone', 'Books not part of a series.'),
(8, 'ACOTAR', 'A Court of Thorns and Roses fantasy romance series.'),
(9, 'Mistborn', 'Epic fantasy series by Brandon Sanderson.'),
(10, 'Percy Jackson', 'Greek mythology-based YA fantasy series.'),
(11, 'Divergent', 'YA dystopian series by Veronica Roth.'),
(12, 'Hercule Poirot', 'Mystery series featuring the Belgian detective Hercule Poirot.'),
(13, 'Sherlock Holmes', 'Classic detective stories featuring Sherlock Holmes and Dr. Watson.'),
(14, 'Dune Saga', 'Epic science fiction series set in the distant future.'),
(15, 'Kings Of Sins', 'The Kings of Sin series features seven billionaire, morally gray “Kings,” each inspired by a deadly sin, and the women who become their weakness. Every book delivers intense chemistry, high heat, emotional drama, and dark, addictive romance. Each story follows a new couple and can be read as a standalone.'),
(16, 'Gods Of The Game', 'Gods of the Game is a steamy sports romance series centered on elite, superstar athletes known as the “Gods,” each with fame, talent, and flaws that make them irresistible. Every book follows a different athlete and the woman who challenges him, blending high heat, drama, emotional tension, and the glamour—and darkness—of professional sports. Each story can be read as a standalone.'),
(17, 'If Love', 'The If Love series is a set of interconnected contemporary romances following friends navigating college, careers, heartbreak, and second chances. Each book focuses on a different couple and blends emotional tension, slow-burn chemistry, drama, and personal growth. Light, heartfelt, and addictive, the series explores love, friendship, and finding yourself, and each book can be read as a standalone.'),
(18, 'Slammed', 'A heartfelt new-adult romance following Layken and Will, two young people dealing with grief, family responsibilities, and a forbidden connection that tests their strength. Expect emotional twists, poetry slams, and a journey of love, loss, and healing.'),
(19, 'Hopeless', 'A deep, emotional series centered on Sky and Holder as they uncover buried trauma, dark secrets, and a past that connects them in shocking ways. It explores heartbreak, healing, identity, and second chances, with companion stories showing different perspectives.'),
(20, 'Maybe', 'A mix of music, friendship, and complicated love, this duet follows Sydney, Ridge, and their tangled relationships as they navigate loyalty, emotional conflict, and creative connection. A blend of angst, melodies, and messy, real-life love.'),
(21, 'It Ends With Us', 'A powerful, emotional journey exploring love, heartbreak, and breaking generational cycles. Lily’s relationship with Ryle and reconnection with Atlas create a story about strength, survival, and choosing better. The duet follows healing, closure, and new beginnings.'),
(22, 'Never Never', 'A mystery romance about two teens who lose their memories repeatedly and must uncover the truth behind their connection, their past, and the strange force affecting them. A blend of suspense, drama, love, and shocking twists.');

-- --------------------------------------------------------

--
-- Table structure for table `shelves`
--

CREATE TABLE `shelves` (
  `shelf_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `is_default` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `shelves`
--

INSERT INTO `shelves` (`shelf_id`, `user_id`, `name`, `is_default`, `created_at`) VALUES
(1, 1, 'Currently Reading', 1, '2025-11-24 06:59:52'),
(2, 1, 'Read', 1, '2025-11-24 06:59:52'),
(3, 1, 'Want To Read', 1, '2025-11-24 06:59:52'),
(4, 2, 'Currently Reading', 1, '2025-11-24 07:01:56'),
(5, 2, 'Read', 1, '2025-11-24 07:01:56'),
(6, 2, 'Want To Read', 1, '2025-11-24 07:01:56'),
(7, 3, 'Currently Reading', 1, '2025-11-24 07:24:12'),
(8, 3, 'Read', 1, '2025-11-24 07:24:12'),
(9, 3, 'Want To Read', 1, '2025-11-24 07:24:12'),
(10, 4, 'Currently Reading', 1, '2025-11-24 07:25:42'),
(11, 4, 'Read', 1, '2025-11-24 07:25:42'),
(12, 4, 'Want To Read', 1, '2025-11-24 07:25:42'),
(13, 5, 'Currently Reading', 1, '2025-11-24 07:26:43'),
(14, 5, 'Read', 1, '2025-11-24 07:26:43'),
(15, 5, 'Want To Read', 1, '2025-11-24 07:26:43'),
(16, 6, 'Currently Reading', 1, '2025-11-24 07:29:15'),
(17, 6, 'Read', 1, '2025-11-24 07:29:15'),
(18, 6, 'Want To Read', 1, '2025-11-24 07:29:15'),
(19, 7, 'Currently Reading', 1, '2025-11-24 07:30:54'),
(20, 7, 'Read', 1, '2025-11-24 07:30:54'),
(21, 7, 'Want To Read', 1, '2025-11-24 07:30:54'),
(22, 8, 'Currently Reading', 1, '2025-11-24 07:32:35'),
(23, 8, 'Read', 1, '2025-11-24 07:32:35'),
(24, 8, 'Want To Read', 1, '2025-11-24 07:32:35'),
(25, 9, 'Currently Reading', 1, '2025-11-24 07:35:43'),
(26, 9, 'Read', 1, '2025-11-24 07:35:43'),
(27, 9, 'Want To Read', 1, '2025-11-24 07:35:43'),
(28, 10, 'Currently Reading', 1, '2025-11-24 07:38:07'),
(29, 10, 'Read', 1, '2025-11-24 07:38:07'),
(30, 10, 'Want To Read', 1, '2025-11-24 07:38:07'),
(31, 11, 'Currently Reading', 1, '2025-11-24 07:40:06'),
(32, 11, 'Read', 1, '2025-11-24 07:40:06'),
(33, 11, 'Want To Read', 1, '2025-11-24 07:40:06'),
(34, 6, 'liked', 0, '2025-11-24 10:22:55'),
(35, 12, 'Currently Reading', 1, '2025-11-24 10:25:54'),
(36, 12, 'Read', 1, '2025-11-24 10:25:54'),
(37, 12, 'Want To Read', 1, '2025-11-24 10:25:54'),
(38, 3, 'Liked', 0, '2025-11-25 02:14:51'),
(39, 13, 'Currently Reading', 1, '2025-11-25 09:47:22'),
(40, 13, 'Read', 1, '2025-11-25 09:47:22'),
(41, 13, 'Want To Read', 1, '2025-11-25 09:47:22');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--


-- --------------------------------------------------------

--
-- Table structure for table `user_genres`
--

CREATE TABLE `user_genres` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `genre_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user_genres`
--

INSERT INTO `user_genres` (`id`, `user_id`, `genre_id`) VALUES
(126, 2, 5),
(125, 2, 6),
(127, 2, 7),
(121, 2, 9),
(124, 2, 10),
(123, 2, 13),
(122, 2, 14),
(113, 3, 1),
(119, 3, 5),
(116, 3, 6),
(120, 3, 7),
(114, 3, 8),
(118, 3, 22),
(112, 3, 23),
(117, 3, 25),
(115, 3, 32),
(132, 4, 1),
(131, 4, 3),
(128, 4, 12),
(130, 4, 26),
(129, 4, 30),
(37, 5, 4),
(40, 5, 5),
(38, 5, 8),
(36, 5, 14),
(41, 5, 17),
(35, 5, 27),
(39, 5, 33),
(103, 6, 3),
(98, 6, 9),
(104, 6, 18),
(102, 6, 19),
(105, 6, 21),
(101, 6, 23),
(99, 6, 29),
(100, 6, 30),
(53, 7, 2),
(50, 7, 10),
(49, 7, 13),
(48, 7, 23),
(51, 7, 32),
(52, 7, 33),
(59, 8, 17),
(57, 8, 20),
(58, 8, 21),
(55, 8, 22),
(56, 8, 24),
(60, 8, 28),
(54, 8, 34),
(134, 9, 15),
(138, 9, 31),
(133, 9, 39),
(135, 9, 40),
(136, 9, 45),
(137, 9, 47),
(68, 10, 1),
(67, 10, 3),
(70, 10, 5),
(72, 10, 11),
(71, 10, 17),
(69, 10, 18),
(66, 10, 19),
(73, 11, 9),
(76, 11, 20),
(77, 11, 21),
(75, 11, 22),
(74, 11, 29),
(110, 12, 6),
(108, 12, 10),
(107, 12, 14),
(106, 12, 27),
(111, 12, 28),
(109, 12, 33),
(141, 13, 3),
(139, 13, 4),
(144, 13, 7),
(142, 13, 8),
(143, 13, 17),
(140, 13, 47);

-- --------------------------------------------------------

--
-- Table structure for table `user_search_history`
--

CREATE TABLE `user_search_history` (
  `history_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `search_query` varchar(255) DEFAULT NULL,
  `search_date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user_search_history`
--

INSERT INTO `user_search_history` (`history_id`, `user_id`, `search_query`, `search_date`) VALUES
(1, 9, 'Atomic Habits', '2025-11-24 07:36:13'),
(2, 9, 'Ana', '2025-11-24 07:36:24'),
(3, 9, 'Alex Volkov', '2025-11-24 07:36:36'),
(4, 4, 'Chetan Bhagat', '2025-11-24 08:51:06'),
(5, 4, 'Chetan Bhagat', '2025-11-24 08:52:02'),
(6, 5, 'Chetan Bhagat', '2025-11-24 08:53:40'),
(7, 2, 'Chetan Bhagat', '2025-11-24 08:54:59'),
(8, 2, 'fiction', '2025-11-24 08:55:19'),
(9, 2, 'Chetan Bhagat', '2025-11-24 08:55:31'),
(10, 2, 'fantasy', '2025-11-24 09:02:07'),
(11, 2, 'horro', '2025-11-24 09:03:08'),
(12, 2, 'thriller', '2025-11-24 09:03:23'),
(13, 6, 'harry porter', '2025-11-24 10:20:35'),
(14, 6, 'harry potter', '2025-11-24 10:20:42'),
(15, 12, 'history', '2025-11-24 10:28:00'),
(16, 12, 'gandhi', '2025-11-24 10:28:14'),
(17, 3, 'indian', '2025-11-24 18:05:37'),
(18, 3, 'states', '2025-11-24 18:20:37'),
(19, 3, 'twisted love', '2025-11-24 18:31:41'),
(20, 3, 'horror', '2025-11-24 18:31:52'),
(21, 3, 'twisted love', '2025-11-25 02:14:33'),
(22, 2, 'twisted', '2025-11-25 03:07:49'),
(23, 2, 'twisted', '2025-11-25 03:11:37'),
(24, 2, 'twisted', '2025-11-25 03:15:54'),
(25, 2, 'twisted', '2025-11-25 03:28:26'),
(26, 2, 'colleen hoover', '2025-11-25 03:28:33'),
(27, 2, 'colleen hoover', '2025-11-25 03:39:27'),
(28, 2, 'history', '2025-11-25 06:52:30'),
(29, 13, 'twisted lies', '2025-11-25 09:49:08'),
(30, 3, 'states', '2025-12-23 18:04:26'),
(31, 3, '2 states', '2025-12-23 18:04:47'),
(32, 3, 'states', '2025-12-23 18:05:04'),
(33, 3, 'sttes', '2025-12-23 18:05:16'),
(34, 3, 'leson', '2025-12-23 18:05:45'),
(35, 3, 'lesson', '2025-12-23 18:05:50'),
(36, 3, 'leson', '2025-12-23 18:05:57'),
(37, 3, 'stats', '2025-12-23 18:10:37'),
(38, 3, 'states', '2025-12-23 18:10:45'),
(39, 3, 'lesson', '2025-12-23 18:10:49'),
(40, 3, '2 states', '2025-12-23 18:10:57'),
(41, 3, 'twisted love', '2025-12-23 18:11:07'),
(42, 3, 'hate', '2025-12-23 18:11:14'),
(43, 3, 'twisted hate', '2025-12-23 18:11:23'),
(44, 3, 'twisted love', '2025-12-23 18:11:32'),
(45, 3, 'twisted lie', '2025-12-23 18:11:36'),
(46, 3, 'love', '2025-12-23 18:13:27'),
(47, 3, 'luv', '2025-12-23 18:13:33'),
(48, 3, 'luve', '2025-12-23 18:13:37'),
(49, 3, 'hate', '2025-12-23 18:13:44'),
(50, 3, 'hat', '2025-12-23 18:13:47'),
(51, 3, 'hte', '2025-12-23 18:13:56'),
(52, 3, 'leson', '2025-12-23 18:14:01'),
(53, 3, 'george martin', '2025-12-24 21:18:39'),
(54, 3, 'george', '2025-12-24 21:18:42'),
(55, 3, 'sarah maas', '2025-12-24 21:24:06'),
(56, 3, 'sarah', '2025-12-24 21:24:09'),
(57, 3, 'brandon', '2025-12-24 21:24:20'),
(58, 3, 'ravinder', '2025-12-24 21:24:33'),
(59, 3, 'john green', '2025-12-24 21:24:43'),
(60, 3, 'veronica roth', '2025-12-24 21:24:52'),
(61, 3, 'paulo', '2025-12-24 21:25:01'),
(62, 3, 'khaled', '2025-12-24 21:25:08'),
(63, 3, 'murakami', '2025-12-24 21:25:14'),
(64, 3, 'ruskin', '2025-12-24 21:25:22'),
(65, 3, 'chetan', '2025-12-24 21:25:28'),
(66, 3, 'rick', '2025-12-24 21:25:35'),
(67, 3, 'taylor', '2025-12-24 21:25:42'),
(68, 3, 'jojo', '2025-12-24 21:25:49'),
(69, 3, 'elif', '2025-12-24 21:25:54'),
(70, 3, 'agatha', '2025-12-24 21:26:01'),
(71, 3, 'arthur', '2025-12-24 21:26:08'),
(72, 3, 'orwell', '2025-12-24 21:26:14'),
(73, 3, 'harper lee', '2025-12-24 21:26:21'),
(74, 3, 'F. Scott Fitzgerald', '2025-12-24 21:26:31'),
(75, 3, 'sudha', '2025-12-24 21:26:37'),
(76, 3, 'abdul kalam', '2025-12-24 21:26:46'),
(77, 3, 'arundhati', '2025-12-24 21:26:53'),
(78, 3, 'frank', '2025-12-24 21:26:59'),
(79, 3, 'gillian', '2025-12-24 21:27:05'),
(80, 3, 'alex', '2025-12-24 21:27:11'),
(81, 3, 'fyodar', '2025-12-24 21:27:29'),
(82, 3, 'Fyodor Dostoevsky', '2025-12-24 21:27:39'),
(83, 3, 'gabriel', '2025-12-24 21:27:49'),
(84, 3, 'abhinav', '2025-12-24 21:27:57'),
(85, 3, 'abhinav', '2025-12-24 21:31:56'),
(86, 3, 'playig it my way', '2025-12-24 21:32:56'),
(87, 3, 'playing it my way', '2025-12-24 21:33:01'),
(88, 3, 'abhinav', '2025-12-24 21:34:28'),
(89, 3, 'self help', '2025-12-24 21:52:55'),
(90, 3, 'self', '2025-12-24 21:52:58'),
(91, 3, 'help', '2025-12-24 21:53:04'),
(92, 3, 'the silent patient', '2025-12-24 22:09:13'),
(93, 3, 'gillian', '2025-12-24 22:09:24'),
(94, 3, 'shining', '2025-12-24 22:09:34'),
(95, 3, 'the call', '2025-12-24 22:09:40'),
(96, 3, 'the shining', '2025-12-24 22:09:52'),
(97, 3, 'jane', '2025-12-24 22:26:40'),
(98, 3, 'Thinking, Fast and Slow', '2025-12-24 22:34:29'),
(99, 3, 'How to Win Friends and Influence People', '2025-12-24 22:51:01'),
(100, 3, 'Atomic Habits', '2025-12-24 22:51:35');

-- --------------------------------------------------------
CREATE TABLE user_book_views (
    view_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    book_id INT,
    view_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
--
-- Table structure for table `user_shelf_books`
--

CREATE TABLE `user_shelf_books` (
  `shelf_id` int(11) NOT NULL,
  `book_id` int(11) NOT NULL,
  `added_date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user_shelf_books`
--

INSERT INTO `user_shelf_books` (`shelf_id`, `book_id`, `added_date`) VALUES
(4, 4, '2025-11-25 06:54:22'),
(5, 5, '2025-11-25 06:52:55'),
(5, 26, '2025-11-25 06:53:56'),
(5, 53, '2025-11-25 09:42:05'),
(6, 19, '2025-11-25 06:54:08'),
(8, 10, '2025-11-24 18:20:22'),
(8, 25, '2025-11-25 00:47:12'),
(8, 53, '2025-11-24 18:20:46'),
(12, 15, '2025-11-25 07:02:03'),
(15, 35, '2025-11-24 11:26:11'),
(26, 82, '2025-11-25 07:16:55'),
(28, 89, '2025-11-25 07:27:05'),
(29, 90, '2025-11-25 07:24:55'),
(29, 91, '2025-11-25 07:26:05'),
(30, 24, '2025-11-25 07:27:14'),
(34, 58, '2025-11-24 10:22:55'),
(38, 24, '2025-11-25 02:15:42');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `authors`
--
ALTER TABLE `authors`
  ADD PRIMARY KEY (`author_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `books`
--
ALTER TABLE `books`
  ADD PRIMARY KEY (`book_id`),
  ADD KEY `author_id` (`author_id`),
  ADD KEY `series_id` (`series_id`);

--
-- Indexes for table `book_genres`
--
ALTER TABLE `book_genres`
  ADD PRIMARY KEY (`book_id`,`genre_id`),
  ADD KEY `genre_id` (`genre_id`);

--
-- Indexes for table `follows`
--
ALTER TABLE `follows`
  ADD PRIMARY KEY (`follow_id`),
  ADD UNIQUE KEY `follower_id` (`follower_id`,`following_id`),
  ADD KEY `idx_following` (`following_id`),
  ADD KEY `idx_follower` (`follower_id`);

--
-- Indexes for table `friend_requests`
--
ALTER TABLE `friend_requests`
  ADD PRIMARY KEY (`request_id`),
  ADD UNIQUE KEY `requester_id` (`requester_id`,`requestee_id`),
  ADD KEY `idx_requestee` (`requestee_id`),
  ADD KEY `idx_status` (`status`);

--
-- Indexes for table `genres`
--
ALTER TABLE `genres`
  ADD PRIMARY KEY (`genre_id`),
  ADD UNIQUE KEY `genre_name` (`genre_name`);

--
-- Indexes for table `reviews`
--
ALTER TABLE `reviews`
  ADD PRIMARY KEY (`review_id`),
  ADD UNIQUE KEY `unique_user_book` (`user_id`,`book_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `book_id` (`book_id`);

--
-- Indexes for table `series`
--
ALTER TABLE `series`
  ADD PRIMARY KEY (`series_id`);

--
-- Indexes for table `shelves`
--
ALTER TABLE `shelves`
  ADD PRIMARY KEY (`shelf_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `user_genres`
--
ALTER TABLE `user_genres`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`,`genre_id`),
  ADD KEY `genre_id` (`genre_id`);

--
-- Indexes for table `user_search_history`
--
ALTER TABLE `user_search_history`
  ADD PRIMARY KEY (`history_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `user_shelf_books`
--
ALTER TABLE `user_shelf_books`
  ADD PRIMARY KEY (`shelf_id`,`book_id`),
  ADD KEY `book_id` (`book_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `authors`
--
ALTER TABLE `authors`
  MODIFY `author_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=69;

--
-- AUTO_INCREMENT for table `books`
--
ALTER TABLE `books`
  MODIFY `book_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=102;

--
-- AUTO_INCREMENT for table `follows`
--
ALTER TABLE `follows`
  MODIFY `follow_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `friend_requests`
--
ALTER TABLE `friend_requests`
  MODIFY `request_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `genres`
--
ALTER TABLE `genres`
  MODIFY `genre_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=63;

--
-- AUTO_INCREMENT for table `reviews`
--
ALTER TABLE `reviews`
  MODIFY `review_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `series`
--
ALTER TABLE `series`
  MODIFY `series_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `shelves`
--
ALTER TABLE `shelves`
  MODIFY `shelf_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `user_genres`
--
ALTER TABLE `user_genres`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=145;

--
-- AUTO_INCREMENT for table `user_search_history`
--
ALTER TABLE `user_search_history`
  MODIFY `history_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=101;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `books`
--
ALTER TABLE `books`
  ADD CONSTRAINT `books_ibfk_1` FOREIGN KEY (`author_id`) REFERENCES `authors` (`author_id`),
  ADD CONSTRAINT `books_ibfk_2` FOREIGN KEY (`series_id`) REFERENCES `series` (`series_id`);

--
-- Constraints for table `book_genres`
--
ALTER TABLE `book_genres`
  ADD CONSTRAINT `book_genres_ibfk_1` FOREIGN KEY (`book_id`) REFERENCES `books` (`book_id`),
  ADD CONSTRAINT `book_genres_ibfk_2` FOREIGN KEY (`genre_id`) REFERENCES `genres` (`genre_id`);

--
-- Constraints for table `follows`
--
ALTER TABLE `follows`
  ADD CONSTRAINT `follows_ibfk_1` FOREIGN KEY (`follower_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `follows_ibfk_2` FOREIGN KEY (`following_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `friend_requests`
--
ALTER TABLE `friend_requests`
  ADD CONSTRAINT `friend_requests_ibfk_1` FOREIGN KEY (`requester_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `friend_requests_ibfk_2` FOREIGN KEY (`requestee_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `reviews`
--
ALTER TABLE `reviews`
  ADD CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`book_id`) REFERENCES `books` (`book_id`);

--
-- Constraints for table `shelves`
--
ALTER TABLE `shelves`
  ADD CONSTRAINT `shelves_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `user_genres`
--
ALTER TABLE `user_genres`
  ADD CONSTRAINT `user_genres_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `user_genres_ibfk_2` FOREIGN KEY (`genre_id`) REFERENCES `genres` (`genre_id`);

--
-- Constraints for table `user_search_history`
--
ALTER TABLE `user_search_history`
  ADD CONSTRAINT `user_search_history_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `user_shelf_books`
--
ALTER TABLE `user_shelf_books`
  ADD CONSTRAINT `user_shelf_books_ibfk_1` FOREIGN KEY (`shelf_id`) REFERENCES `shelves` (`shelf_id`),
  ADD CONSTRAINT `user_shelf_books_ibfk_2` FOREIGN KEY (`book_id`) REFERENCES `books` (`book_id`);
COMMIT;

ALTER TABLE reviews
ADD CONSTRAINT fk_reviews_user
FOREIGN KEY (user_id)
REFERENCES users(user_id)
ON DELETE CASCADE
ON UPDATE CASCADE;


ALTER TABLE user_book_views
ADD CONSTRAINT fk_views_user
FOREIGN KEY (user_id)
REFERENCES users(user_id)
ON DELETE CASCADE
ON UPDATE CASCADE;



/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
