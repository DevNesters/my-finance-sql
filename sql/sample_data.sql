-- Person
INSERT INTO person (name, email) VALUES
('Cher Joshua Her', 'cherjher@gmail.com'),
('Pa Nhia Yang', 'pyang4@gmail.com');    

-- Income Categories
INSERT INTO income_categories (name, description) VALUES
('Salary', 'Monthly salary from employer'),
('Bonuses', 'Year-end and performance bonuses'),
('Reimbursements', 'Church-related reimbursements'),
('Gifts', 'Monetary gifts from family and friends');

-- Income Transactions
INSERT INTO income_transactions (person_id, category_id, amount, transaction_date, description) VALUES
(1, 1, 5000.00, '2024-01-31', 'January Salary'),
(1, 2, 1000.00, '2024-02-15', 'Performance Bonus'),
(2, 1, 6000.00, '2024-01-31', 'January Salary'),
(2, 3, 200.00, '2024-02-10', 'Church Reimbursement');   

-- Expenses Categories
INSERT INTO expenses_categories (name, description) VALUES
('Mortgage', 'Monthly house mortgage'),
('Utilities', 'Electricity, water, internet bills'),
('Groceries', 'Monthly grocery shopping'),
('Dining Out', 'Restaurants and takeout meals'),
('Transportation', 'Public transport and fuel costs'),
('Entertainment', 'Movies, concerts, and other leisure activities'),
('Healthcare', 'Medical expenses and insurance'),
('Miscellaneous', 'Other unplanned expenses');

-- Expenses Transactions
INSERT INTO expenses_transactions (person_id, category_id, amount, transaction_date, description) VALUES
(1, 1, 1500.00, '2024-01-05', 'January Mortgage Payment'),
(1, 2, 200.00, '2024-01-10', 'Electricity Bill'),
(1, 3, 300.00, '2024-01-15', 'Grocery Shopping'),
(1, 4, 100.00, '2024-01-20', 'Dinner at Italian Restaurant'),
(1, 5, 50.00, '2024-01-12','Monthly Metro Card'),
(1, 6, 75.00, '2024-01-12','Movie Night'),
(1, 7, 120.00, '2024-01-12','Doctor Visit'),
(1, 8, 60.00, '2024-01-12','Gift for Friend'),
(2, 2, 180.00, '2024-01-12', 'Water Bill'),
(2, 3, 350.00, '2024-01-18', 'Grocery Shopping'),
(2, 4, 90.00, '2024-01-22', 'Takeout Dinner'),
(2, 5, 55.00, '2024-01-12','Fuel for Car'),
(2, 6, 80.00, '2024-01-12','Concert Tickets'),
(2, 7, 150.00, '2024-01-12','Pharmacy Purchase'),
(2, 8, 40.00, '2024-01-12','Office Supplies');

