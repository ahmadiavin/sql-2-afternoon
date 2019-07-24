-- Get all invoices where the unit_price on the invoice_line is greater than $0.99.

SELECT *
FROM invoice_line
WHERE unit_price > 0.99

-- Get the invoice_date, customer first_name and last_name, and total from all invoices.

SELECT invoice.invoice_date, customer.first_name, customer.last_name
FROM customer 
INNER JOIN invoice
ON customer.customer_id = invoice.customer_id

-- Get the customer first_name and last_name and the support rep's first_name and last_name from all customers.

SELECT employee.first_name, employee.last_name, customer.first_name, customer.last_name
FROM customer 
INNER JOIN employee
ON customer.support_rep_id = employee.employee_id

-- Get the album title and the artist name from all albums.
SELECT album.title, artist.name
FROM album 
INNER JOIN artist
ON album.artist_id = artist.artist_id

-- Get all playlist_track track_ids where the playlist name is Music.
SELECT playlist.name, playlist_track.track_id
FROM playlist_track
INNER JOIN playlist
ON playlist.playlist_id = playlist_track.playlist_id 
WHERE name = 'Music'
-- Get all track names for playlist_id 5.
SELECT  playlist_track.playlist_id, track.name
FROM playlist_track
INNER JOIN track
ON track.track_id = playlist_track.track_id
WHERE playlist_id = 5
-- Get all track names and the playlist name that they're on ( 2 joins ).
SELECT track.name, playlist.name
FROM track
JOIN playlist_track
ON track.track_id = playlist_track.track_id
JOIN playlist 
ON playlist_track.playlist_id = playlist.playlist_id

-- Get all track names and album titles that are the genre Alternative & Punk ( 2 joins ).
SELECT track.name, album.title, genre.name
FROM track
JOIN album
ON track.album_id = album.album_id
JOIN genre
ON track.genre_id = genre.genre_id
WHERE genre.name = 'Alternative & Punk'

-- Get all invoices where the unit_price on the invoice_line is greater than $0.99.
SELECT * FROM invoice_line
WHERE unit_price > 0.99

-- Get all playlist tracks where the playlist name is Music.
SELECT *
FROM playlist_track
WHERE playlist_id IN ( SELECT playlist_id FROM playlist WHERE name = 'Music' );

-- Get all track names for playlist_id 5.
SELECT name
FROM track
WHERE track_id IN ( SELECT track_id FROM playlist_track WHERE playlist_id = 5 );

-- Get all tracks where the genre is Comedy.
SELECT *
FROM track
WHERE genre_id IN ( SELECT genre_id FROM genre WHERE name = 'Comedy' );

-- Get all tracks where the album is Fireball.
SELECT *
FROM track
WHERE album_id IN ( SELECT album_id FROM album WHERE title = 'Fireball' );

-- Get all tracks for the artist Queen ( 2 nested subqueries ).
SELECT *
FROM track
WHERE album_id IN ( SELECT album_id FROM album WHERE artist_id IN(
 SELECT artist_id FROM artist WHERE name = 'Queen') );

-- Find all customers with fax numbers and set those numbers to null.
UPDATE customer 
SET fax = null
WHERE fax IS NOT null

-- Find all customers with no company (null) and set their company to "Self".
UPDATE customer 
SET company = 'Self'
WHERE company IS null

-- Find the customer Julia Barnett and change her last name to Thompson.
UPDATE customer 
SET last_name = 'Thompson'
WHERE last_name = 'Barnett' AND first_name = 'Julia'

-- Find the customer with this email luisrojas@yahoo.cl and change his support rep to 4.
UPDATE customer 
SET support_rep_id = 4
WHERE email = 'luisrojas@yahoo.cl'

-- Find all tracks that are the genre Metal and have no composer. Set the composer to "The darkness around us".
UPDATE track 
SET composer = 'The darkness around us'
WHERE genre_id = (SELECT genre_id FROM genre WHERE name = 'Metal')
AND composer IS null;

-- Find a count of how many tracks there are per genre. Display the genre name with the count.
SELECT count(*), genre.name
FROM track
JOIN genre 
ON track.genre_id = genre.genre_id
GROUP BY genre.name

-- Find a count of how many tracks are the "Pop" genre and how many tracks are the "Rock" genre.
SELECT count(*), genre.name
FROM track
JOIN genre 
ON track.genre_id = genre.genre_id
WHERE genre.name = 'Pop' OR genre.name ='Rock'
GROUP BY genre.name

-- Find a list of all artists and how many albums they have.
SELECT count(*), artist.name
FROM album 
JOIN artist  
ON album.artist_id = artist.artist_id
GROUP BY artist.name

-- From the track table find a unique list of all composers.
SELECT DISTINCT composer
FROM track

-- From the invoice table find a unique list of all billing_postal_codes.
SELECT DISTINCT billing_postal_code
FROM invoice

-- From the customer table find a unique list of all companys.
SELECT DISTINCT company
FROM customer

-- Delete all 'bronze' entries from the table.
DELETE FROM practice_delete WHERE type = 'bronze'

-- Delete all 'silver' entries from the table.
DELETE FROM practice_delete WHERE type = 'silver'

-- Delete all entries whose value is equal to 150.
DELETE FROM practice_delete WHERE value = 150;


               ------------------------------------------ E-COMMERCE 

CREATE TABLE aa_users ( name_id SERIAL PRIMARY KEY, name TEXT, email TEXT );
INSERT INTO aa_users ( name_id, name, email ) VALUES (1, 'Jim', 'Jim@aol.com');
INSERT INTO aa_users ( name_id, name, email ) VALUES (2, 'Pam', 'Pam@aol.com');
INSERT INTO aa_users ( name_id, name, email ) VALUES (3, 'Dwight', 'Dwight@aol.com');

CREATE TABLE aa_products ( product_id SERIAL PRIMARY KEY, name TEXT, price INTEGER );
INSERT INTO aa_products ( product_id, name, price ) VALUES (1, 'Paper', 499);
INSERT INTO aa_products ( product_id, name, price ) VALUES (2, 'Candy', 399);
INSERT INTO aa_products ( product_id, name, price ) VALUES (3, 'Beets', 199);

CREATE TABLE aa_orders ( order_id SERIAL PRIMARY KEY, product_id INT, name_id INT);
INSERT INTO aa_orders ( order_id, product_id, name_id ) VALUES (1, 1, 1);
INSERT INTO aa_orders ( order_id, product_id, name_id ) VALUES (2, 2, 2);
INSERT INTO aa_orders ( order_id, product_id, name_id ) VALUES (3, 3, 3);



-- Get all products for the first order.
SELECT aa_products.name
FROM aa_products
INNER JOIN aa_orders
ON aa_products.product_id = aa_orders.product_id
LIMIT 1
-- Get all orders.
SELECT * FROM aa_orders
-- Get the total cost of an order ( sum the price of all products on an order ).
SELECT sum(price)
FROM aa_products
JOIN aa_orders
ON aa_products.product_id = aa_orders.product_id

-- Add a foreign key reference from orders to users.
ALTER TABLE aa_orders
ADD FOREIGN KEY (product_id) REFERENCES aa_products(product_id);

-- Update the orders table to link a user to each order.
UPDATE aa_orders
SET name_id = aa_orders.name_id
FROM aa_users
WHERE aa_orders.name_id = aa_users.name_id
-- Get all orders for a user.
SELECT aa_orders.order_id
FROM aa_orders
INNER JOIN aa_users
ON aa_users.name_id = aa_orders.name_id

-- Get how many orders each user has.

SELECT count(*), aa_orders.order_id
FROM aa_orders 
JOIN aa_users 
ON aa_orders.name_id = aa_users.name_id
GROUP BY aa_orders.order_id 
