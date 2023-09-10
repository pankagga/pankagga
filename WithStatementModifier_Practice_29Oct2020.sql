CREATE TABLE All_Trips3
(Origin CHAR(3) NOT NULL
, Destination CHAR(3) NOT NULL
, Cost INT
, Depth INT)
PRIMARY INDEX (origin);

INSERT INTO All_Trips3 VALUES ('LAX', 'BOS', 545,2);

INSERT INTO All_Trips2 VALUES ('LAX', 'BOS', 390,1);
INSERT INTO All_Trips2 VALUES ('LAX', 'CHI', 365,1);

INSERT INTO All_Trips1 VALUES ('LAX', 'BOS', 300,0);
INSERT INTO All_Trips1 VALUES ('LAX', 'SFO', 90,0);
INSERT INTO flights VALUES ('SFO', 'CHI', 275);
INSERT INTO flights VALUES ('CHI', 'BOS', 180);
INSERT INTO All_Trips1 VALUES ('LAX', 'ATL', 250,0);
INSERT INTO flights VALUES ('ATL', 'BOS', 140);
SELECT * FROM Flights ORDER BY 1;



WITH RECURSIVE All_Trips
(Origin,Destination,Cost,Depth) AS
(
--Basic Query
SELECT Origin, Destination, Cost, 0
FROM Flights WHERE Origin = 'LAX'

UNION ALL
--Recursive Query
/*
SELECT All_Trips3.Origin, Flights.Destination, All_Trips3.Cost + Flights.cost, All_Trips3.Depth + 1
FROM All_Trips3 INNER JOIN Flights ON All_Trips3.Destination = Flights.Origin 

SELECT All_Trips2.Origin, Flights.Destination, All_Trips2.Cost + Flights.cost, All_Trips2.Depth + 1
FROM All_Trips2 INNER JOIN Flights ON All_Trips2.Destination = Flights.Origin 

SELECT All_Trips1.Origin, Flights.Destination, All_Trips1.Cost + Flights.cost, All_Trips1.Depth + 1
FROM All_Trips1 INNER JOIN Flights ON All_Trips1.Destination = Flights.Origin 

AND All_Trips.Depth < 3*/

SELECT All_Trips.Origin, Flights.Destination, All_Trips.Cost + Flights.cost, All_Trips.Depth + 1
FROM All_Trips INNER JOIN Flights ON All_Trips.Destination = Flights.Origin AND All_Trips.Depth < 3

)
SELECT * FROM All_Trips;
CREATE RECURSIVE VIEW All_Trips_View
(Origin,
Destination,
Cost,
Depth) AS
(
SELECT Origin, Destination, Cost, 0
FROM Flights
WHERE Origin = 'LAX'
UNION ALL
SELECT All_Trips_View.Origin,
Flights.Destination,
All_Trips_View.Cost + Flights.cost,
All_Trips_View.Depth + 1
FROM All_Trips_View, Flights
WHERE All_Trips_View.Destination = Flights.Origin
AND All_Trips_View.Depth < 3
);

SELECT * FROM All_Trips_View WHERE Depth = 0;
SELECT * FROM All_Trips_View WHERE Depth = 1;
SELECT * FROM All_Trips_View WHERE Depth = 2;

