CREATE TABLE IF NOT EXISTS factures (
    id INT PRIMARY KEY AUTO_INCREMENT,
    client_id INT NOT NULL,
    date DATE NOT NULL,
    total DECIMAL(10,2) NOT NULL,
    status VARCHAR(50) NOT NULL,
    FOREIGN KEY (client_id) REFERENCES client(id)
);
