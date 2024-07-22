-- Data Definition Language (DFL)
-- ------------------------------

CREATE TABLE TRAIN (
    id NUMBER PRIMARY KEY,
    speed NUMBER,
    seats NUMBER
);

CREATE TABLE STATION (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(20)
);

CREATE TABLE TRIP (
    id NUMBER PRIMARY KEY,
    departure REFERENCES STATION(id),
    arrival REFERENCES STATION(id),
    schedule TIMESTAMP,
    distance NUMBER,
    price NUMBER,
    train REFERENCES TRAIN(id)
);

CREATE TABLE TRAVELER (
    id NUMBER PRIMARY KEY,
    phone VARCHAR2(20),
    name VARCHAR2(20),
    birthday DATE
);

CREATE TABLE TICKET (
    trip REFERENCES TRIP (id),
    traveler REFERENCES TRAVELER (id),
    purchased DATE,
    PRIMARY KEY (trip, traveler)
);

-- Data Manipulation Language (DML)
-- --------------------------------

INSERT INTO TRAIN (id, speed, seats) VALUES (1, 200, 100);
INSERT INTO TRAIN (id, speed, seats) VALUES (2, 180, 100);
INSERT INTO TRAIN (id, speed, seats) VALUES (3, 220, 100);

INSERT INTO STATION (id, name) VALUES (1, 'Riyadh');
INSERT INTO STATION (id, name) VALUES (2, 'Makkah');
INSERT INTO STATION (id, name) VALUES (3, 'Madinah');
INSERT INTO STATION (id, name) VALUES (4, 'Dammam');

INSERT INTO TRIP (id, departure, arrival, schedule, distance, price, train)
VALUES (1, 1, 2, TIMESTAMP'2023-05-01 08:00:00', 300, 50, 1);
INSERT INTO TRIP (id, departure, arrival, schedule, distance, price, train)
VALUES (2, 2, 3, TIMESTAMP'2023-05-02 10:00:00', 1000, 100, 2);
INSERT INTO TRIP (id, departure, arrival, schedule, distance, price, train)
VALUES (3, 3, 4, TIMESTAMP'2023-05-03 12:00:00', 2500, 200, 3);

INSERT INTO TRAVELER (id, phone, name, birthday) VALUES (1, '1111111111', 'Mohammad', DATE'1990-01-15');
INSERT INTO TRAVELER (id, phone, name, birthday) VALUES (2, '2222222222', 'Saleh', DATE'1985-07-20');
INSERT INTO TRAVELER (id, phone, name, birthday) VALUES (3, '3333333333', 'Ahmad', DATE'1978-03-10');
INSERT INTO TRAVELER (id, phone, name, birthday) VALUES (4, '4444444444', 'Mazen', DATE'1991-03-28');

INSERT INTO TICKET (trip, traveler, purchased) VALUES (1, 1, DATE'2023-04-25');
INSERT INTO TICKET (trip, traveler, purchased) VALUES (2, 2, DATE'2023-04-26');
INSERT INTO TICKET (trip, traveler, purchased) VALUES (3, 3, DATE'2023-04-27');
INSERT INTO TICKET (trip, traveler, purchased) VALUES (3, 4, DATE'2023-04-27');

-- Queries and Tasks
-- -----------------

-- TASK 01: Retrieve all train information including train number, speed, and other relevant details.
SELECT * FROM TRAIN;

-- TASK 02: List all stations along with their station code and name.
SELECT * FROM STATION;

-- TASK 03: Display the schedule for a specific trip, including departure city, arrival city, departure time, distance, and price.
SELECT p.id, d.name AS departure, a.name AS arrival, p.schedule, p.distance, p.price, p.train
FROM TRIP p, STATION d, STATION a
WHERE p.id = 1 AND p.departure = d.id AND p.arrival = a.id;

-- TASK 04: Show traveler information such as name, phone number, and age.
SELECT t.*, TRUNC((SYSDATE - birthday) / 365.25) AS AGE FROM TRAVELER t WHERE id = 1;

-- TASK 05: Retrieve ticket information for a given date, including trip number and client number.
SELECT * FROM TICKET;

-- TASK 06: List all booked tickets for a specific client.
SELECT * FROM TICKET WHERE traveler = 1;

-- TASK 07: Display the available train schedules for a given date.
SELECT * FROM TRIP WHERE TRUNC(schedule) = DATE'2023-05-01';

-- TASK 08: Show the total number of available seats for each trip.
SELECT p.*, (n.seats - (SELECT COUNT(*) FROM TICKET WHERE trip = p.id)) AS available_seats
FROM TRIP p, TRAIN n WHERE p.train = n.id;

-- TASK 09: List all trips with their corresponding departure and arrival cities.
SELECT p.id, d.name AS departure, a.name AS arrival, p.schedule, p.distance, p.price, p.train
FROM TRIP p, STATION d, STATION a
WHERE p.departure = d.id AND p.arrival = a.id;

-- TASK 10: Display the total revenue generated from ticket sales for a specific date range.
SELECT SUM(p.price) AS revenue
FROM TICKET t, TRIP p
WHERE t.trip = p.id AND purchased BETWEEN DATE'2023-04-25' AND DATE'2023-04-28';

-- TASK 11: Show the average speed of all trains.
SELECT id, seats, AVG(speed) FROM TRAIN GROUP BY id;

-- TASK 12: Retrieve the most popular departure and arrival cities based on the number of trips.
SELECT STATS_MODE(departure) AS popular_departure, STATS_MODE(arrival) AS popular_arrival FROM TRIP;

-- TASK 13: List all trips sorted by departure time.
SELECT * FROM TRIP ORDER BY schedule;

-- TASK 14: Display the total distance traveled by each train.
SELECT train, SUM(distance) AS traveled_distance FROM TRIP WHERE schedule < SYSDATE GROUP BY train;

-- TASK 15: Show the total number of tickets booked for each trip.
SELECT trip, COUNT(*) AS num_tickets FROM TICKET GROUP BY trip;
