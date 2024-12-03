CREATE DATABASE app_food;
USE app_food;

CREATE TABLE food_type (
	type_id INT AUTO_INCREMENT,
	type_name VARCHAR(255) NOT NULL,
	
	-- PK
	PRIMARY KEY (type_id)
);


CREATE TABLE user (
	user_id INT AUTO_INCREMENT,
	full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    
    -- PK
    PRIMARY KEY (user_id)
);

-- N - 1 food_type
CREATE TABLE food (
	food_id INT AUTO_INCREMENT,
	food_name VARCHAR(255) NOT NULL,
	image VARCHAR(255),
	price FLOAT NOT NULL,
	`desc` VARCHAR(255),
	type_id INT NOT NULL,

	-- Khóa chính
	PRIMARY KEY (food_id),
	-- FK food_type
	FOREIGN KEY (type_id) REFERENCES food_type(type_id) ON DELETE CASCADE
);

-- tg user & food
CREATE TABLE `order` (
	user_id INT NOT NULL,
	food_id INT NOT NULL,
	amount INT,
	code VARCHAR(255),
	arr_sub_id VARCHAR(255),

	-- PK
	PRIMARY KEY (user_id, food_id),
	-- FK user
	FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE CASCADE,
	-- FK food
	FOREIGN KEY (food_id) REFERENCES food(food_id) ON DELETE CASCADE
);

-- N - 1 food
CREATE TABLE sub_food (
	sub_id INT AUTO_INCREMENT,
	sub_name VARCHAR(255) NOT NULL,
	sub_price FLOAT,
	food_id INT,
	
	-- PK
	PRIMARY KEY (sub_id),
	-- FK food
	FOREIGN KEY (food_id) REFERENCES food(food_id) ON DELETE CASCADE
);


CREATE TABLE restaurant (
	res_id INT AUTO_INCREMENT,
	res_name VARCHAR(255) NOT NULL,
	image VARCHAR(255),
	`desc` VARCHAR(255),
	
	-- PK
	PRIMARY KEY (res_id)
);

-- tg user & restaurant
CREATE TABLE rate_res (
	user_id INT NOT NULL,
	res_id INT NOT NULL,
	amount INT NOT NULL,
	date_rate DATETIME NOT NULL,
	
	-- PK
	PRIMARY KEY (user_id, res_id),
	-- FK user
	FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE CASCADE,
	-- FK restaurant
	FOREIGN KEY (res_id) REFERENCES restaurant(res_id) ON DELETE CASCADE
);

-- tg user & restaurant
CREATE TABLE like_res (
	user_id INT NOT NULL,
	res_id INT NOT NULL,
	date_like DATETIME NOT NULL,
	
	-- PK
	PRIMARY KEY (user_id, res_id),
	-- FK user
	FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE CASCADE,
	-- FK restaurant
	FOREIGN KEY (res_id) REFERENCES restaurant(res_id) ON DELETE CASCADE
);

-- 1 ----------------------------------
SELECT 
    user_id, 
    COUNT(*) AS like_count
FROM 
    like_res
GROUP BY 
    user_id
ORDER BY 
    like_count DESC
LIMIT 5;

-- 2 ----------------------------------
SELECT 
    res_id, 
    COUNT(*) AS like_count
FROM 
    like_res
GROUP BY 
    res_id
ORDER BY 
    like_count DESC
LIMIT 2;

-- 3 ----------------------------------
SELECT 
    user_id, 
    COUNT(*) AS order_count
FROM 
    `order`
GROUP BY 
    user_id
ORDER BY 
    order_count DESC
LIMIT 1;

-- 4 ----------------------------------
SELECT 
    u.user_id, 
    u.full_name
FROM 
    user u
LEFT JOIN 
    `order` o ON u.user_id = o.user_id
LEFT JOIN 
    like_res l ON u.user_id = l.user_id
LEFT JOIN 
    rate_res r ON u.user_id = r.user_id
WHERE 
    o.user_id IS NULL 
    AND l.user_id IS NULL 
    AND r.user_id IS NULL;




