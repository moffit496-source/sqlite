
UPDATE products SET stock = 10 WHERE id = 1;


INSERT INTO orders (user_id, product_id, quantity, total, status) 
VALUES (1, 1, 50, 75000, 'pending');


SELECT * FROM products;