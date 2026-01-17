-- Dimension table creation section

    -- Time Dimension Table 
    CREATE TABLE time_dimension(
    time_id NUMBER(6) PRIMARY KEY,
    month VARCHAR2(50),
    fiscal_quarter VARCHAR2(2) NOT NULL,
    year NUMBER(4) NOT NULL,
    month_num NUMBER(2) NOT NULL,
    season VARCHAR2(50) NOT NULL,
    time_date DATE NOT NULL);

    -- Airline Dimension Table
    CREATE TABLE airline_dimension(
    airline_id VARCHAR2(3) PRIMARY KEY,
    airline_name VARCHAR2(100) NOT NULL,
    airline_type VARCHAR2(100) NOT NULL,
    country VARCHAR2(100) NOT NULL,
    latitude FLOAT NOT NULL,
    longitude FLOAT NOT NULL);

    -- Airline Dimension Table

    CREATE TABLE airport_dimension(
    airport_id VARCHAR2(5) PRIMARY KEY,
    airport_name VARCHAR2(100) NOT NULL);
    
    -- Area Dimension Table 

    CREATE TABLE area_dimension(
    area_id VARCHAR2(4) PRIMARY KEY,
    area_name VARCHAR2(100) NOT NULL,
    area_region VARCHAR2(100) NOT NULL);

    -- Service Ratings Dimension Table 

    CREATE TABLE service_ratings_dimension(
    ratings_id VARCHAR2(4) PRIMARY KEY,
    ratings VARCHAR2(100) NOT NULL,
    avg_delay_thres VARCHAR2(100) NOT NULL,
    on_time_thres NUMBER(10) NOT NULL,
    cancellation_thres VARCHAR2(50) NOT NULL);

-- Fact table creation section

    CREATE TABLE airport_punctuality_fact(
    punct_id VARCHAR2(7) PRIMARY KEY,
    time_id NUMBER(6),
    airline_id VARCHAR2(5),
    airport_id VARCHAR2(3),
    ratings_id VARCHAR2(4),
    area_id VARCHAR2(4),
    num_of_flights NUMBER(6) DEFAULT 0,
    num_of_flights_cancelled NUMBER(6) DEFAULT 0,
    avg_early_on_time_flights FLOAT DEFAULT 0,
    avg_cancelled_flights FLOAT DEFAULT 0,
    total_minutes_delayed FLOAT DEFAULT 0,
    min_delays_minutes FLOAT DEFAULT 0,
    max_delays_minutes FLOAT DEFAULT 0,
    avg_delays_minutes FLOAT DEFAULT 0,
    CONSTRAINT fk_time_id FOREIGN KEY (time_id) REFERENCES
    time_dimension(time_id),
    CONSTRAINT fk_airline_id FOREIGN KEY (airline_id) REFERENCES
    airline_dimension(airline_id),
    CONSTRAINT fk_airport_id FOREIGN KEY (airport_id) REFERENCES
    airport_dimension(airport_id),
    CONSTRAINT fk_ratings_id FOREIGN KEY (ratings_id) REFERENCES
    service_ratings_dimension(ratings_id),
    CONSTRAINT fk_area_id FOREIGN KEY (area_id) REFERENCES
    area_dimension(area_id));
