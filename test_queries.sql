-- Connect to the 'postgres' database
\c postgres;

-- 1. Retrieve all annonces for a specific city
SELECT a.*
FROM annonce a
JOIN city c ON a.city_id = c.id
WHERE c.name = 'Casablanca';

-- 2. Filter annonces by the number of rooms and bathrooms
SELECT *
FROM annonce
WHERE nb_rooms >= 2 AND nb_baths >= 1;

-- 3. Filter annonces by a price range
SELECT *
FROM annonce
WHERE price BETWEEN 100000 AND 500000;

-- 4. Get annonces with a specific equipment (e.g., 'Balcony')
SELECT a.*
FROM annonce a
JOIN annonce_equipment ae ON a.id = ae.annonce_id
JOIN equipment e ON ae.equipment_id = e.id
WHERE e.name = 'Balcony';
func
from property_management_db import City, Annonce, Equipment, engine

# Initialize the sess
-- 5. Count the number of annonces per city
SELECT c.name AS city_name, COUNT(a.id) AS annonce_count
FROM city c
LEFT JOIN annonce a ON c.id = a.city_id
GROUP BY c.name
ORDER BY annonce_count DESC;

-- 6. Find annonces by surface area (e.g., greater than 100 m²)
SELECT *
FROM annonce
WHERE surface_area > 100;

-- 7. Retrieve annonces by date of publication (e.g., last 30 days)
SELECT *
FROM annonce
WHERE datetime >= NOW() - INTERVAL '30 days';

-- 8. List all cities
SELECT * FROM city;

-- 9. List all equipments
SELECT * FROM equipment;

-- 10. Retrieve all annonces along with their associated city and equipment
SELECT a.id, a.title, a.price, c.name AS city_name, e.name AS equipment_name
FROM annonce a
JOIN city c ON a.city_id = c.id
LEFT JOIN annonce_equipment ae ON a.id = ae.annonce_id
LEFT JOIN equipment e ON ae.equipment_id = e.id
ORDER BY a.id;

-- 11. Count the number of annonces for each equipment type
SELECT e.name AS equipment_name, COUNT(ae.annonce_id) AS annonce_count
FROM equipment e
LEFT JOIN annonce_equipment ae ON e.id = ae.equipment_id
GROUP BY e.name
ORDER BY annonce_count DESC;

-- 12. Find the most expensive annonce
SELECT *
FROM annonce
ORDER BY price DESC
LIMIT 1;

-- 13. Find the cheapest annonce
SELECT *
FROM annonce
ORDER BY price ASC
LIMIT 1;

-- 14. Average price of annonces per city
SELECT c.name AS city_name, AVG(a.price) AS avg_price
FROM city c
JOIN annonce a ON c.id = a.city_id
GROUP BY c.name
ORDER BY avg_price DESC;

-- 15. Total number of annonces
SELECT COUNT(*) AS total_annonces FROM annonce;

-- End of the SQL queries file
