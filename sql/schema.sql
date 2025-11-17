-- Scheme for personal finance database
-- Tables: person, income, income_categories, income_transactions, expenses_categories, expenses_transactions
CREATE TABLE person (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE income_categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT
);
CREATE TABLE income_transactions (
    id SERIAL PRIMARY KEY,
    person_id INT REFERENCES person(id),
    category_id INT REFERENCES income_categories(id),
    amount DECIMAL(10, 2) NOT NULL,
    transaction_date DATE NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE expenses_categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT
);
CREATE TABLE expenses_transactions (
    id SERIAL PRIMARY KEY,
    person_id INT REFERENCES person(id),
    category_id INT REFERENCES expenses_categories(id),
    amount DECIMAL(10, 2) NOT NULL,
    transaction_date DATE NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
