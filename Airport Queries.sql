-- Visualisation One: Comparing Six Major UK Airports 

    SELECT 
    ap.punct_id,
    tim.month,
    tim.time_date,
    ap.airport_id,
    ai.airport_name,
    ap.ratings_id,
    rt.ratings,

    ap.num_of_flights,
    ap.num_of_flights_cancelled,
    ap.avg_early_on_time_flights,
    ap.avg_cancelled_flights,
    ap.total_minutes_delayed,
    ap.min_delays_minutes,
    ap.avg_delays_minutes

    FROM airport_punctuality_fact ap 
    JOIN time_dimension tim ON ap.time_id = tim.time_id
    JOIN airport_dimension ai ON ap.airport_id = ai.airport_id
    JOIN airline_dimension al ON ap.airline_id = al.airline_id
    JOIN area_dimension ar ON ap.area_id = ar.area_id
    JOIN service_ratings_dimension rt ON ap.ratings_id = rt.ratings_id
    WHERE ai.airport_name IN ('HEATHROW', 'GATWICK', 'MANCHESTER', 'STANSTED', 'LUTON', 'EDINBURGH')
    ORDER BY ai.airport_name, tim.time_date;

-- Visualisation Two: Quarterly Performance of Airlines Average on Time

    SELECT
    al.airline_id,
    al.airline_name,
    tim.time_date,
    SUM(ap.num_of_flights) AS total_flights,
    ROUND(AVG(ap.avg_early_on_time_flights), 2) AS avg_on_time,
    ROUND(AVG(ap.avg_delays_minutes), 2) AS avg_delays_minutes
    FROM airport_punctuality_fact ap 
    JOIN airline_dimension al ON ap.airline_id = al.airline_id
    JOIN time_dimension tim ON ap.time_id = tim.time_id 
    WHERE ap.airline_id IN (
        SELECT airline_id 
        FROM airport_punctuality_fact
        GROUP BY airline_id ORDER BY SUM(num_of_flights) DESC
        FETCH FIRST 10 ROWS ONLY)
    GROUP BY al.airline_id, al.airline_name, tim.time_date ORDER BY al.airline_name, tim.time_date;

-- Visualisation Three: Airports with the highest poor ratings 

    SELECT 
    ar.area_id,
    ar.area_name,
    rt.ratings_id,
    rt.ratings AS ratings_label,
    AVG(ad.latitude) AS latitude, 
    AVG(ad.longitude) AS longitude,
    COUNT(*) AS rating_count
    FROM airport_punctuality_fact ap 
    JOIN service_ratings_dimension rt ON ap.ratings_id = rt.ratings_id
    JOIN area_dimension ar ON ap.area_id = ar.area_id
    JOIN airport_dimension ad ON ap.airport_id = ad.airport_id
    GROUP BY ar.area_id, ar.area_name, rt.ratings_id, rt.ratings
    ORDER BY ar.area_name, rt.ratings_id;

-- Visualisation Four: Avg. Delays Minutes vs Avg. Cancelled Flights per Airline 

    SELECT 
    al.airline_name,
    ROUND(AVG(ap.avg_delays_minutes), 2) AS avg_delays_minutes,
    ROUND(AVG(ap.avg_cancelled_flights), 2) AS avg_cancelled_flights,
    SUM(ap.num_of_flights) AS total_flights
    FROM airport_punctuality_fact ap 
    JOIN airline_dimension al ON ap.airline_id = al.airline_id 
    GROUP BY al.airline_name HAVING AVG(ap.avg_delays_minutes) <= 40 AND AVG(ap.avg_cancelled_flights) <= 20; 



