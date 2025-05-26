-- Active: 1748182827012@@127.0.0.1@5432@conservation_db@public

-- create rangers, species, and sightings tables 
CREATE TABLE rangers (
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(25) NOT NULL,
    region VARCHAR(100) NOT NULL
);
CREATE TABLE species (
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(25) NOT NULL,
    scientific_name VARCHAR(100) NOT NULL,
    discovery_date DATE NOT NULL,
    conservation_status VARCHAR(25) NOT NULL
);

CREATE TABLE sightings (
    sighting_id SERIAL PRIMARY KEY,
    species_id INT REFERENCES species(species_id) NOT NULL,
    ranger_id INT REFERENCES rangers(ranger_id) NOT NULL,
    location VARCHAR(50) NOT NULL,
    sighting_time TIMESTAMP NOT NULL,
    notes TEXT
);


-- Insert sample data into rangers table
INSERT INTO rangers (name, region) VALUES 
('Alice Green', 'Northern Hills'), 
('Bob White', 'River Delta'), 
('Carol King', 'Mountain Range');

-- Insert sample data into species table
INSERT INTO species (common_name, scientific_name, discovery_date, conservation_status) VALUES 
('Snow Leopard', 'Panthera uncia', '1775-01-01', 'Endangered'),
('Bengal Tiger', 'Panthera tigris tigris', '1758-01-01', 'Endangered'),
('Red Panda', 'Ailurus fulgens', '1825-01-01', 'Vulnerable'),
('Asiatic Elephant', 'Elephas maximus indicus', '1758-01-01', 'Endangered')

-- Insert sample data into sightings table
INSERT INTO sightings (species_id, ranger_id, location, sighting_time, notes) VALUES 
(1, 1, 'Peak Ridge', '2024-05-10 07:45:00', 'Camera trap image captured'),
(2, 2, 'Bankwood Area', '2024-05-12 16:20:00', 'Juvenile seen'),
(3, 3, 'Bamboo Grove East', '2024-05-15 09:10:00', 'Feeding observed'),
(1, 2, 'Snowfall Pass', '2024-05-18 18:30:00', NULL);


-- Problem 1️⃣ - Register a new ranger with provided data with name = 'Derek Fox' and region = 'Coastal Plains'
INSERT INTO rangers (name, region) VALUES ('Derek Fox', 'Coastal plains');

-- Problem 2️⃣ - Count unique species ever sighted.
SELECT COUNT(DISTINCT species_id) AS unique_species_count FROM sightings;

-- Problem 3️⃣ - Find all sightings where the location includes "Pass".
SELECT * FROM sightings WHERE location LIKE '%Pass%';

-- Problem 4️⃣ - List each ranger's name and their total number of sightings.
SELECT r.name, COUNT(s.sighting_id) AS total_sightings FROM sightings AS s JOIN rangers AS r ON s.ranger_id = r.ranger_id GROUP BY r.name;

-- Problem 5️⃣ - List species that have never been sighted.
SELECT common_name FROM species WHERE species_id NOT IN (SELECT DISTINCT species_id FROM sightings);

-- Problem 6️⃣ - Show the most recent 2 sightings.
SELECT common_name, sighting_time, name FROM sightings AS s JOIN rangers AS r ON s.ranger_id = r.ranger_id JOIN species ON s.species_id = species.species_id ORDER BY sighting_time DESC LIMIT 2;

-- Problem 7️⃣ - Update all species discovered before year 1800 to have status 'Historic'.
 UPDATE species SET conservation_status = 'Historic' WHERE discovery_date < '1800-01-01';

-- Problem 8️⃣ - Label each sighting's time of day as 'Morning', 'Afternoon', or 'Evening'
SELECT s.sighting_id,
       CASE 
           WHEN EXTRACT(HOUR FROM s.sighting_time) < 12 THEN 'Morning'
           WHEN EXTRACT(HOUR FROM s.sighting_time) < 18 THEN 'Afternoon'
           ELSE 'Evening'
       END AS time_of_day
FROM sightings AS s;

-- Problem 9️⃣ - Delete rangers who have never sighted any species
DELETE FROM rangers WHERE ranger_id NOT IN (SELECT DISTINCT ranger_id FROM sightings);