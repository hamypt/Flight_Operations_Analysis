-- CREATE TEMPORARY TABLES

CREATE TABLE temp_airlines (
    airline_id INT,
    carrier VARCHAR(10),
    carrier_name VARCHAR(100),
    carrier_region VARCHAR(1)
);

CREATE TABLE temp_airports (
    airport_id INT,
    airport_code VARCHAR(10),
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100)
);

CREATE TABLE temp_aircrafts (
    aircraft_type INT,
    aircraft_group INT
);

CREATE TABLE temp_flights (
    flight_id INT AUTO_INCREMENT PRIMARY KEY,
    airline_id INT,
    aircraft_type INT,
    origin_airport_id INT,
    destination_airport_id INT,
    departures_scheduled INT,
    departures_performed INT,
    payload INT,
    seats INT,
    passengers INT,
    freight INT,
    mail INT,
    distance INT,
    ramp_to_ramp INT,
    air_time INT,
    year INT, 
    month INT,
    distance_group INT,
    class VARCHAR(10),
    data_source VARCHAR(10)
);


-- IMPORT DATA FROM CSV FILES INTO TEMPORARY TABLES

LOAD DATA LOCAL INFILE '/pathname/airlines.csv'
INTO TABLE temp_airlines
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(airline_id, carrier_region, carrier, carrier_name)
;

LOAD DATA LOCAL INFILE '/pathname/aircrafts.csv'
INTO TABLE temp_aircrafts
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(aircraft_group, aircraft_type)
;

LOAD DATA LOCAL INFILE '/pathname/origin airports.csv'
INTO TABLE temp_airports
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(airport_id, airport_code, city, state, country)
;
    
LOAD DATA LOCAL INFILE '/pathname/dest airports.csv'
INTO TABLE temp_airports
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(airport_id, airport_code, city, state, country)
;

LOAD DATA LOCAL INFILE '/pathname/flights.csv'
INTO TABLE temp_flights
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(departures_scheduled, departures_performed, payload, seats, passengers, freight, mail, 
distance, ramp_to_ramp, air_time, airline_id, origin_airport_id, destination_airport_id, aircraft_type,
year, month, distance_group, class, data_source)
;

-- INSERT UNIQUE RECORDS INTO FINAL TABLES AND DROP TEMPORARY TABLES

CREATE TABLE airlines AS SELECT DISTINCT * FROM temp_airlines;
CREATE TABLE airports AS SELECT DISTINCT * FROM temp_airports;
CREATE TABLE aircrafts AS SELECT DISTINCT * FROM temp_aircrafts;
CREATE TABLE flights AS SELECT DISTINCT * FROM temp_flights;

DROP TABLE temp_airlines;
DROP TABLE temp_airports;
DROP TABLE temp_aircrafts;
DROP TABLE temp_flights;

-- DEFINE FOREIGN KEYS

ALTER TABLE airlines
ADD INDEX idx_airline_id (airline_id);

ALTER TABLE aircrafts
ADD INDEX idx_aircraft_type (aircraft_type);

ALTER TABLE airports
ADD INDEX idx_airport_id (airport_id);

ALTER TABLE flights
ADD CONSTRAINT airline_id
	FOREIGN KEY (airline_id) REFERENCES airlines(airline_id) ON DELETE SET NULL,
ADD CONSTRAINT aircraft_type
    FOREIGN KEY (aircraft_type) REFERENCES aircrafts(aircraft_type) ON DELETE SET NULL,
ADD CONSTRAINT origin_airport_id
    FOREIGN KEY (origin_airport_id) REFERENCES airports(airport_id) ON DELETE SET NULL,
ADD CONSTRAINT destination_airport_id
    FOREIGN KEY (destination_airport_id) REFERENCES airports(airport_id) ON DELETE SET NULL;
