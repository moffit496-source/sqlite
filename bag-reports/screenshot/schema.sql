CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE products (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(150) NOT NULL,
    price NUMERIC(10, 2) NOT NULL CHECK (price >= 0),
    stock INTEGER NOT NULL CHECK (stock >= 0)
);

CREATE TABLE orders (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    total NUMERIC(10, 2) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'completed', 'cancelled')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);



INSERT INTO users (name, email) VALUES ('Иван', 'ivan@mail.ru');
INSERT INTO products (name, price, stock) VALUES ('Наушники', 1500.00, 10);
INSERT INTO orders (user_id, product_id, quantity, total, status) VALUES (1, 1, 2, 3000.00, 'pending');
CREATE TRIGGER trg_order_created
AFTER INSERT ON orders
FOR EACH ROW
BEGIN
    UPDATE products 
    SET stock = stock - NEW.quantity 
    WHERE id = NEW.product_id;
END;

CREATE TRIGGER trg_order_cancelled
AFTER UPDATE OF status ON orders
FOR EACH ROW
WHEN NEW.status = 'cancelled' AND OLD.status != 'cancelled'
BEGIN
    UPDATE products 
    SET stock = stock + OLD.quantity 
    WHERE id = OLD.product_id;
END;



