-- --------------------------------------------------------
-- Table: phone_models
-- Stores the base information and pricing variables for the phones available for loan.
-- The loan risk variables (deposit_percent, annual_interest_rate) are the BASE values.
-- Final values are risk-adjusted by the application logic based on the user's age.
-- --------------------------------------------------------
CREATE TABLE phone_models (
    -- Unique identifier for the phone model (Primary Key)
    id SERIAL PRIMARY KEY,

    -- Name of the phone model (e.g., 'Yellow 5G')
    model_name VARCHAR(255) NOT NULL,

    -- The cash price of the phone before any loan calculation
    cash_price NUMERIC(10, 2) NOT NULL CHECK (cash_price > 0),

    -- Base deposit percentage (as a decimal, e.g., 0.15 for 15%)
    -- Note: The actual deposit will be risk-adjusted by the application.
    deposit_percent NUMERIC(5, 4) NOT NULL CHECK (deposit_percent BETWEEN 0 AND 1),

    -- Base annual interest rate (as a decimal, e.g., 0.20 for 20%)
    -- Note: The actual rate will be risk-adjusted by the application.
    annual_interest_rate NUMERIC(5, 4) NOT NULL CHECK (annual_interest_rate > 0),

    -- Ensures each model name is unique
    UNIQUE (model_name)
);

-- --------------------------------------------------------
-- Table: loan_applications
-- Stores the final submission data, including user input and all calculated loan values.
-- --------------------------------------------------------
CREATE TABLE loan_applications (
    -- Unique identifier for the application (Primary Key)
    id SERIAL PRIMARY KEY,

    -- 13-digit South African ID number
    sa_id_number VARCHAR(13) NOT NULL,

    -- Full name of the applicant
    full_name VARCHAR(255) NOT NULL,

    -- Birthday extracted from the SA ID number
    birthday DATE NOT NULL,

    -- Applicant's self-declared gross monthly income
    monthly_income NUMERIC(10, 2) NOT NULL CHECK (monthly_income > 0),

    -- Foreign Key reference to the phone_models table
    phone_id INTEGER NOT NULL REFERENCES phone_models(id) ON DELETE RESTRICT,

    -- The principal amount loaned (Cash Price minus Deposit)
    loan_principal NUMERIC(10, 2) NOT NULL,

    -- The total amount to be repaid (Principal + Interest over 360 days)
    total_loan_amount NUMERIC(10, 2) NOT NULL,

    -- The final daily payment amount calculated
    daily_payment NUMERIC(10, 2) NOT NULL,

    -- Status of the application (e.g., PENDING, APPROVED, REJECTED)
    status VARCHAR(50) NOT NULL DEFAULT 'PENDING',

    -- Timestamp for when the application was created
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    -- CRITICAL CONSTRAINT: Ensures no duplicate applications based on SA ID
    UNIQUE (sa_id_number)
);

-- --------------------------------------------------------
-- Seed Data Example (for PostgreSQL)
-- This data is needed to populate the phone selection dropdown in the frontend.
-- --------------------------------------------------------
INSERT INTO phone_models (model_name, cash_price, deposit_percent, annual_interest_rate) VALUES
('Yellow 5G', 2500.00, 0.1000, 0.2000),
('Gold Standard', 4500.00, 0.1500, 0.1800),
('Entry Tier', 1800.00, 0.0500, 0.2500),
('Premium Ultra', 7500.00, 0.2000, 0.1500),
('Budget Buddy', 1200.00, 0.0500, 0.3000),
('Mid-Range Marvel', 3000.00, 0.1200, 0.2200),
('Flagship Pro', 6000.00, 0.1800, 0.1600),
('Compact Classic', 2000.00, 0.0800, 0.2800),
('Mega Max', 8500.00, 0.2200, 0.1400);