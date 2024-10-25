create table product_category (
    category_id serial PRIMARY KEY,
    category_name varchar(255) NOT NULL
);

create table product (
    product_id serial PRIMARY KEY,
    product_name varchar(255) NOT NULL,
    measurement_unit varchar(15) NOT NULL,
    price_per_unit int CHECK (price_per_unit >= 0 AND price_per_unit <= 1000000),
    calorie_content int CHECK (calorie_content >= 0 AND calorie_content <= 1000),
    product_category_id int NOT NULL REFERENCES product_category(category_id) ON UPDATE SET NULL ON DELETE CASCADE
);

create table recipe (
    recipe_id serial PRIMARY KEY,
    recipe_name varchar(255) NOT NULL,
    number_of_servings int CHECK (number_of_servings > 0 AND number_of_servings < 10000)
);

create table recipe_product (
    recipe_id int NOT NULL REFERENCES recipe(recipe_id) ON UPDATE CASCADE ON DELETE CASCADE,
    product_id int NOT NULL REFERENCES product(product_id) ON UPDATE CASCADE ON DELETE CASCADE,
    number_of_product_units double precision CHECK (number_of_product_units >= 0 AND number_of_product_units <= 1000),
    product_instructions varchar,
    serial_number int CHECK (serial_number > 0),
    PRIMARY KEY (recipe_id, product_id)
);

create table recipe_category (
    category_id serial PRIMARY KEY,
    category_name varchar(255) NOT NULL
);

create table recipe_recipe_category (
    recipe_id int NOT NULL REFERENCES recipe(recipe_id) ON UPDATE CASCADE ON DELETE SET NULL,
    category_id int NOT NULL REFERENCES recipe_category(category_id) ON UPDATE CASCADE ON DELETE SET NULL,
    PRIMARY KEY (recipe_id, category_id)
);