    -- Example SQL data for population
    --   CREATE USER claimdb;
    --   CREATE DATABASE claimdb ENCODING UTF8;
    --   GRANT ALL PRIVILEGES ON DATABASE claimdb TO claimdb;

    --   ALTER USER claimdb WITH PASSWORD 'claimdb';
       \c claimdb;
      CREATE TABLE order_items (
        id VARCHAR(255),
        orderid VARCHAR(255),
        description VARCHAR(255),
        amount INT,
        year INT
      );
      ALTER TABLE order_items OWNER TO claimdb;

      CREATE TABLE orders (
          id VARCHAR(255),
          status VARCHAR(255)
      );
      ALTER TABLE orders OWNER TO claimdb;

      INSERT INTO order_items (id, orderid, description, amount, year)
      VALUES 
      ('001', 'ORD1001', 'Wireless Keyboard', 45, 2024),
      ('002', 'ORD1001', 'Bluetooth Mouse', 30, 2024),
      ('003', 'ORD1002', 'USB-C Charger', 25, 2023);

      INSERT INTO orders (id, status)
      VALUES 
      ('ORD1001', 'IN_PROGRESS');
