# 📚 Book Recommendation System

A personalized **Book Recommendation System** developed using **Python, Flask, and MySQL** that recommends books based on their similarity to users' interests. The system leverages **Content-Based Filtering** with **Cosine Similarity** to provide intelligent recommendations through a user-friendly web interface.

---

## 📖 Project Overview

The Book Recommendation System was developed as an academic group project to demonstrate practical knowledge of **Machine Learning, Data Preprocessing, Database Design, and Web Development**.

The application analyzes user-book interaction data and book metadata to generate personalized recommendations. It integrates a Flask-based web application with a MySQL database to provide an end-to-end recommendation platform.

---

## ❓ Problem Statement

With thousands of books available, readers often struggle to discover books aligned with their interests.

Traditional search methods require users to manually browse large collections, making it difficult to identify relevant books.

This project addresses the problem by recommending books based on similarity analysis, helping users discover books that closely match their preferences.

---

## 🎯 Objectives

- Build a personalized book recommendation engine.
- Apply Machine Learning concepts to a real-world problem.
- Perform data preprocessing on user-book interaction data.
- Design a relational database to efficiently manage book and user information.
- Develop an interactive web application using Flask.
- Demonstrate practical implementation of recommendation algorithms.

---

# 🏗 Development Methodology

The project followed the Software Development Life Cycle (SDLC):

1. Requirement Gathering
2. System Analysis
3. Dataset Preparation
4. Data Preprocessing
5. Database Design
6. Recommendation Engine Development
7. Flask Web Application Development
8. Database Integration
9. Testing
10. Deployment (Local Environment)

---

# 📋 Requirement Gathering

## Functional Requirements

### User

- Register/Login
- Browse available books
- Search books
- View book details
- Receive personalized recommendations
- Manage personal collection

### Administrator

- Manage users
- Manage books
- Update metadata
- Maintain database
- Monitor system data

---

## Non-Functional Requirements

- User-friendly interface
- Efficient recommendation generation
- Scalable database design
- Secure user authentication
- Fast search performance
- Data consistency

---

# 🏛 System Architecture

```
Presentation Layer
HTML + CSS + JavaScript

↓

Application Layer
Flask (Python)

↓

Recommendation Engine
Content-Based Filtering
Cosine Similarity

↓

Database Layer
MySQL
```

---

# 🛠 Technology Stack

## Programming Language

- Python

## Frontend

- HTML5
- CSS3
- JavaScript

## Backend

- Flask

## Database

- MySQL

## Libraries

- Pandas
- NumPy
- Scikit-learn
- Matplotlib

## Development Tools

- VS Code
- MySQL Workbench
- Git

---

# 🗄 Database Design

The system uses a **normalized relational database** consisting of **13 interconnected tables** to efficiently manage users, books, metadata, and user collections.

### Major Entities

- Users
- Books
- Authors
- Categories
- Publishers
- Ratings
- Reviews
- Reading Lists
- User Collections
- Book Metadata

### Database Concepts Used

- Relational Database Design
- Normalization
- Primary Keys
- Foreign Keys
- SQL Joins
- CRUD Operations
- Referential Integrity

---

# 🤖 Recommendation Engine

The recommendation engine uses **Content-Based Filtering**.

### Algorithm Used

- Cosine Similarity

### Workflow

1. Collect book metadata.
2. Preprocess textual features.
3. Convert features into numerical vectors.
4. Calculate similarity using Cosine Similarity.
5. Recommend books with the highest similarity scores.

---

# 📊 Dataset

The project includes:

- **349+ user-book interaction records**
- **13-table relational database**
- Structured metadata for books and users

---

# ✨ Features

## User Module

- User Registration & Login
- Browse Books
- Search Books
- Personalized Recommendations
- Book Details
- Reading Collection Management

---

## Admin Module

- Manage Users
- Manage Books
- Manage Metadata
- Database Management

---

# 🔄 Project Workflow

```
Requirement Gathering

↓

System Analysis

↓

Dataset Preparation

↓

Data Preprocessing

↓

Database Design

↓

Recommendation Engine

↓

Flask Integration

↓

Testing

↓

Deployment
```

---

# 📈 Machine Learning Concepts

- Content-Based Filtering
- Cosine Similarity
- Feature Engineering
- Similarity Matrix
- Recommendation Systems

---

# 💾 Database Operations

- CRUD Operations
- SQL Queries
- INSERT
- UPDATE
- DELETE
- SELECT
- INNER JOIN
- Data Filtering
- Search Queries

---

# 💻 Software Engineering Concepts

The project demonstrates:

- Requirement Analysis
- SDLC
- Database Design
- Data Modeling
- Machine Learning Workflow
- Flask Web Development
- Modular Programming
- CRUD Operations
- SQL Query Optimization

---

# 🚧 Challenges Faced

- Designing an optimized relational database
- Cleaning and preprocessing user-book interaction data
- Managing multiple interconnected tables
- Implementing an accurate similarity-based recommendation engine
- Integrating the recommendation model with Flask
- Maintaining efficient database queries

---

# 📚 Learning Outcomes

Through this project, I gained practical experience in:

- Python Programming
- Flask Development
- Machine Learning Fundamentals
- Recommendation Systems
- Content-Based Filtering
- Cosine Similarity
- Data Preprocessing
- Relational Database Design
- SQL
- Database Normalization
- Full-Stack Application Development

---

# 🚀 Future Enhancements

- Hybrid Recommendation System
- Collaborative Filtering
- Deep Learning-based Recommendations
- User Rating System
- Personalized User Profiles
- Book Reviews & Reviews Analysis
- Real-time Recommendation Updates
- Cloud Deployment

---

# 📂 Project Structure

```
Book-Recommendation-System/

├── app.py
├── data/
├── static/
│   ├── css/
│   └── images/
├── templates/
├── database/
├── README.md
└── LICENSE
```

---

# 📄 Project Documentation

Complete Software Engineering documentation includes:

- Requirement Gathering
- Functional Requirements
- Non-Functional Requirements
- System Analysis
- Database Design
- ER Diagram
- DFD
- Database Schema
- Test Cases
- UI Screenshots
- Development Process

📄 **Documentation:** *(https://drive.google.com/file/d/1BdkapI9o5-A6gdY-_NUpSDlfIMucWfcW/view?usp=sharing)*

---

# 👩‍💻 My Contributions

As part of a three-member team, my contributions included:

- Database design and normalization
- Flask backend development
- MySQL database integration
- Recommendation engine implementation
- Testing and debugging

---

# 👥 Contributors

- **Ruchita Mahale** – [LinkedIn](https://www.linkedin.com/in/ruchita-mahale/) | [GitHub](https://github.com/rmahale04)
- **Netra Patel**
- **Keyuri Makwana**

---

## ⭐ If you found this project interesting, consider giving it a star!
