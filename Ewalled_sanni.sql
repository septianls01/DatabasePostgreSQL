DROP TABLE IF EXISTS users CASCADE;

CREATE TABLE users (
	id SERIAL PRIMARY KEY,
	full_name VARCHAR NOT NULL,
	username VARCHAR(15) UNIQUE NOT NULL,
	email VARCHAR UNIQUE,
	password VARCHAR NOT NULL,
	avatar VARCHAR,
	phone_num VARCHAR NOT NULL
);

INSERT INTO users (full_name, username, email, password, avatar, phone_num) VALUES
    ('Adi Saputra', 'adi_saputra', 'adi@bsi-rakamin.com', 'secureAdi12', NULL, '081234567890'),
    ('Fitri Handayani', 'fitri_han', 'fitri@bsi-rakamin.com', 'fitriPass!', NULL, '081234567891'),
    ('Dian Permana', 'dianp99', 'dian@bsi-rakamin.com', 'dianSecret1', NULL, '081234567892'),
    ('Rahmat Pratama', 'rahmat07', 'rahmat@bsi-rakamin.com', 'rahmatSecure77', NULL, '081234567893'),
    ('Siti Nurhaliza', 'sitinur', 'siti@bsi-rakamin.com', 'nurhaliza123', NULL, '081234567894'),
    ('Bayu Kurniawan', 'bayu_kur', 'bayu@bsi-rakamin.com', 'bayuSafe99', NULL, '081234567895'),
    ('Indah Puspita', 'indahp', 'indah@bsi-rakamin.com', 'indahSecret', NULL, '081234567896'),
    ('Zainal Arifin', 'zainalar', 'zainal@bsi-rakamin.com', 'zainal987', NULL, '081234567897'),
    ('Melati Dewanti', 'melati_d', 'melati@bsi-rakamin.com', 'melatiPass09', NULL, '081234567898'),
    ('Fauzan Ridho', 'fauzan_r', 'fauzan@bsi-rakamin.com', 'fauzanSec!', NULL, '081234567899');

SELECT * FROM users;

DROP TYPE IF EXISTS status_type CASCADE;
CREATE TYPE status_type AS ENUM ('Sukses', 'Gagal', 'Menunggu');

DROP TYPE IF EXISTS transfer_types CASCADE;
CREATE TYPE transfer_types AS ENUM ('isi saldo', 'kirim saldo');

DROP TABLE IF EXISTS transactions CASCADE;
CREATE TABLE transactions (
	id SERIAL PRIMARY KEY,
	amount MONEY,
	datetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	transaction_no INTEGER UNIQUE,
	transfer_type TRANSFER_TYPES NOT NULL,
	description VARCHAR(255) NOT NULL, 
	sender_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
	recepient_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE
);

INSERT INTO transactions (amount, transaction_no, transfer_type, description, sender_id, recepient_id) 
VALUES
    (25000, 1, 'isi saldo', 'Isi saldo untuk jajan', 2, 1),
    (50000, 2, 'kirim saldo', 'Bayar tagihan listrik', 4, 3),
    (75000, 3, 'kirim saldo', 'Belanja kebutuhan bulanan', 1, 5),
    (100000, 4, 'isi saldo', 'Isi saldo aplikasi belanja', 3, 2),
    (120000, 5, 'kirim saldo', 'Bayar tiket bioskop', 6, 4),
    (175000, 6, 'isi saldo', 'Isi saldo aplikasi ride-sharing', 5, 7),
    (5000, 7, 'kirim saldo', 'Bayar parkir', 7, 8),
    (89000, 8, 'isi saldo', 'Isi saldo dompet digital', 9, 2),
    (42000, 9, 'kirim saldo', 'Patungan traktiran', 8, 6),
    (150000, 10, 'isi saldo', 'Isi saldo game online', 10, 3),
    (20000, 11, 'kirim saldo', 'Bayar kopi', 1, 9),
    (30000, 12, 'isi saldo', 'Isi saldo e-wallet untuk transportasi', 3, 10),
    (65000, 13, 'kirim saldo', 'Bayar makanan cepat saji', 2, 6),
    (115000, 14, 'isi saldo', 'Isi saldo langganan streaming', 4, 8),
    (7000, 15, 'kirim saldo', 'Bayar tol elektronik', 5, 9);

SELECT * FROM transactions;

DROP VIEW IF EXISTS transactions_2 CASCADE;
CREATE VIEW transactions_2 AS 
SELECT 
	t.datetime,
	t.description, 
	t.transfer_type, 
	t.amount,
	t.sender_id,
	a.name AS sender_name, 
	t.recepient_id,
	a.name AS recepient_name
FROM transactions AS t
INNER JOIN users AS a ON t.sender_id = a.id ;

select * from transactions_2;

DROP VIEW IF EXISTS transfer_3 CASCADE;
CREATE VIEW transfer_3 AS 
SELECT
	DATE_TRUNC('second', t.datetime) AS truncated_datetime,
	t.transfer_type, 
	t.description,
	t.sender_id,
	t.recepient_id,
	t.amount, 
	CASE WHEN 
		t.transfer_type = 'isi saldo' THEN null 
		ELSE t.sender_name
	END AS sender_name,
	a.name AS recepient_name
FROM transactions_2 AS t
INNER JOIN users AS a ON t.recepient_id = a.id;

SELECT * FROM transfer_3 WHERE sender_id = 2;