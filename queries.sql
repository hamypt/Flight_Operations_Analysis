-- 1. DESCRIPTIVE STATISTICS & SUMMARY

-- 1.1. TOTAL FLIGHT SUMMARY

SELECT
  SUM(departures_scheduled) AS 'Total Scheduled Flights',
  SUM(departures_performed) AS 'Total Performed Flights',
  SUM(payload) AS 'Total Payload',
  SUM(seats) AS 'Total Seats',
  SUM(passengers) AS 'Total Passengers',
  SUM(freight) AS 'Total Freight',
  SUM(mail) AS 'Total Mail'
FROM flights;

-- 1.2. AIRLINE PERFORMANCE

SELECT
  a.carrier_name AS 'Airline',
  COUNT(f.flight_id) AS 'Total Flights',
  SUM(f.air_time) AS 'Total Air Time',
  SUM(f.payload) AS 'Total Payload',
  SUM(f.passengers) AS 'Total Passengers',
  AVG(f.seats) AS 'Average Seats',
  SUM(f.freight) AS 'Total Freight',
  SUM(f.mail) AS 'Total Mail',
  AVG(f.departures_performed / f.departures_scheduled) AS 'Average Performance Ratio'
FROM flights AS f
JOIN airlines AS a ON f.airline_id = a.airline_id
GROUP BY a.carrier_name
ORDER BY COUNT(f.flight_id) DESC;


-- 2. FLIGHT ANALYSIS

-- 2.1. MOST POPULAR ROUTES

SELECT
  o.airport_code AS 'Origin',
  d.airport_code AS 'Destination',
  COUNT(f.flight_id) AS 'Total Flights',
  SUM(f.passengers) AS 'Total Passengers',
  AVG(f.distance) AS 'Average Distance',
  AVG(f.air_time) AS 'Average Air Time'
FROM flights AS f
JOIN airports AS o ON f.origin_airport_id = o.airport_id
JOIN airports AS d ON f.destination_airport_id = d.airport_id
GROUP BY o.airport_code, d.airport_code
ORDER BY COUNT(f.flight_id) DESC
LIMIT 10;

-- 2.2. AIRCRAFT UTILIZATION

SELECT
  aircraft_type AS 'Aircraft Type',
  COUNT(flight_id) AS 'Total Flights',
  AVG(payload) AS 'Average Payload',
  AVG(distance) AS 'Average Distance',
  SUM(air_time) AS 'Total Air Time'
FROM flights
GROUP BY aircraft_type
ORDER BY `Total Flights` DESC;


-- 3. TIME SERIES ANALYSIS

-- 3.1. MONTHLY TRENDS

SELECT
  month AS 'Month',
  SUM(departures_performed) AS 'Total Flights',
  SUM(passengers) AS 'Total Passengers',
  SUM(freight) AS 'Total Freight'
FROM flights
GROUP BY month
ORDER BY month;

-- 3.2. PERFORMANCE OVER TIME

SELECT
  month AS 'Month',
  SUM(departures_performed) AS 'Total Flights',
  SUM(passengers) AS 'Total Passengers',
  AVG(departures_performed / departures_scheduled) AS 'Performance Ratio'
FROM flights
GROUP BY month
ORDER BY month;


-- 4. GEOGRAPHICAL ANALYSIS

-- 4.1. AIRPORT STATISTICS

SELECT 
  p.airport_code AS 'Airport Code',
  COUNT(f.flight_id) AS 'Total Flights',
  COUNT(f.passengers) AS 'Total Passengers',
  SUM(f.freight) AS 'Total Freight'
FROM flights AS f
JOIN airports AS p ON f.origin_airport_id = p.airport_id OR f.destination_airport_id = p.airport_id
GROUP BY p.airport_code
ORDER BY `Total Flights` DESC;

-- 4.2. REGIONAL ANALYSIS

SELECT
  CASE 
    WHEN a.carrier_region = 'A' THEN 'Atlantic'
    WHEN a.carrier_region = 'D' THEN 'Domestic'
    WHEN a.carrier_region = 'I' THEN 'International'
    WHEN a.carrier_region = 'L' THEN 'Latin America'
    WHEN a.carrier_region = 'P' THEN 'Pacific'
    WHEN a.carrier_region = 'S' THEN 'System' 
    ELSE a.carrier_region 
  END AS 'Region',
  COUNT(f.flight_id) AS 'Total Flights',
  SUM(f.passengers) AS 'Total Passengers',
  SUM(f.freight) AS 'Total Freight'
FROM flights AS f
JOIN airlines AS a ON f.airline_id = a.airline_id
GROUP BY `Region`
ORDER BY `Total Flights` DESC;


-- 5. EFFICIENCY & OPERATIONAL ANALYSIS

-- 5.1. OPERATIONAL EFFICIENCY BY AIRLINE

SELECT
  a.carrier_name AS 'Airline',
  NULLIF(AVG(f.ramp_to_ramp), 0) AS 'Average Ramp-to-Ramp Time',
  NULLIF(AVG(f.air_time), 0) AS 'Average Air Time',
  AVG(f.ramp_to_ramp - f.air_time) AS 'Average Delay'
FROM flights AS f
JOIN airlines AS a ON f.airline_id = a.airline_id
GROUP BY `Airline`
ORDER BY `Average Delay` DESC;

-- 5.2. LOAD FACTOR ANALYSIS

SELECT
  a.carrier_name AS 'Airline',
  AVG(f.passengers / f.seats) AS 'Average Load Factor'
FROM flights AS f
JOIN airlines AS a ON f.airline_id = a.airline_id
GROUP BY `Airline`
ORDER BY `Average Load Factor` DESC;


-- 6. ADVANCED ANALYSIS

-- 6.1. PREDICTIVE ANALYSIS

SELECT 
  month AS 'Month',
  SUM(passengers) AS 'Total Passengers',
  AVG(SUM(passengers)) OVER 
    (ORDER BY month ROWS BETWEEN 11 PRECEDING AND CURRENT ROW)
    AS 'Moving Average Passengers'
FROM flights
GROUP BY month
ORDER BY month;

-- 6.2. COHORT ANALYSIS

SELECT
  CONCAT(f.year, '-', LPAD(f.month, 2, '0')) AS 'Month',
  a.carrier_name AS 'Airline',
  COUNT(f.flight_id) AS 'Total Flights',
  AVG(f.passengers) AS 'Average Passengers'
FROM flights AS f
JOIN airlines AS a ON f.airline_id = a.airline_id
GROUP BY CONCAT(f.year, '-', LPAD(f.month, 2, '0')), a.carrier_name
ORDER BY `Month`, `Airline`;

-- 6.3. SEGMENTATION

SELECT
  CASE
    WHEN distance < 500 THEN 'Short Haul'
    WHEN distance BETWEEN 500 AND 1500 THEN 'Medium Haul'
    ELSE 'Long Haul'
  END AS 'Distance Group',
  COUNT(flight_id) AS 'Total Flights',
  AVG(passengers) AS 'Average Passengers',
  SUM(freight) AS 'Total Freight'
FROM flights
GROUP BY `Distance Group`
ORDER BY `Total Flights` DESC;

-- 6.4. SEGMENTATION AND TIME SERIES ANALYSIS

SELECT
  CONCAT(year, '-', LPAD(month, 2, '0')) AS 'Month',
  CASE
    WHEN distance < 500 THEN 'Short haul'
    WHEN distance BETWEEN 500 AND 1500 THEN 'Medium haul'
    ELSE 'Long haul'
  END AS 'Distance Group',
  COUNT(flight_id) AS 'Total Flights',
  AVG(passengers) AS 'Average Passengers',
  STDDEV(passengers) AS 'StdDev Passengers',
  MIN(passengers) AS 'Min Passengers',
  MAX(passengers) AS 'Max Passengers',
  SUM(freight) AS 'Total Freight'
FROM flights
GROUP BY CONCAT(year, '-', LPAD(month, 2, '0')), CASE
      WHEN distance < 500 THEN 'Short Haul'
      WHEN distance BETWEEN 500 AND 1500 THEN 'Medium Haul'
      ELSE 'Long Haul'
    END
ORDER BY `Month`, `Distance Group`;


-- ----------------------------------------------------------------------
