create table product_category (
    category_id serial PRIMARY KEY,
    category_name varchar(255) NOT NULL
);

create table product (
    product_id serial PRIMARY KEY,
    product_name varchar(255) NOT NULL,
    measurement_unit varchar(15) NOT NULL,
    price_per_unit double precision CHECK (price_per_unit >= 0 AND price_per_unit <= 1000000),
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

INSERT INTO product_category (category_name)
VALUES
    ('Овощи'),
    ('Фрукты'),
    ('Молоко и молочные продукты'),
    ('Бакалея'),
    ('Яйца'),
    ('Мясо'),
    ('Специи');

INSERT INTO recipe_category (category_name)
VALUES
    ('Десерт'),
    ('Суп'),
    ('Салат'),
    ('Гарнир'),
    ('Завтрак'),
    ('Вегетарианское блюдо');

INSERT INTO product (product_name, measurement_unit, price_per_unit, calorie_content, product_category_id)
VALUES
    ('Виноград кишмиш', 'килограмм', 225, 63, (SELECT category_id FROM product_category WHERE category_name = 'Фрукты')),
    ('Банан', 'килограмм', 100, 89, (SELECT category_id FROM product_category WHERE category_name = 'Фрукты')),
    ('Молоко', 'литр', 146, 64, (SELECT category_id FROM product_category WHERE category_name = 'Молоко и молочные продукты')),
    ('Сахар', 'килограмм', 59, 387, (SELECT category_id FROM product_category WHERE category_name = 'Бакалея')),
    ('Куриное яйцо', 'количество штук', 12, 157, (SELECT category_id FROM product_category WHERE category_name = 'Яйца')),
    ('Пшеничная мука', 'килограмм', 50, 364, (SELECT category_id FROM product_category WHERE category_name = 'Бакалея')),
    ('Яблоко', 'килограмм', 157, 52, (SELECT category_id FROM product_category WHERE category_name = 'Фрукты')),
    ('Соль', 'чайная ложка', 0.05, 0, (SELECT category_id FROM product_category WHERE category_name = 'Специи')),
    ('Сода', 'чайная ложка', 0.23, 0, (SELECT category_id FROM product_category WHERE category_name = 'Бакалея')),
    ('Растительное масло', 'по вкусу', 10, 899, (SELECT category_id FROM product_category WHERE category_name = 'Бакалея')),
    ('Манная крупа', 'килограмм', 130, 328, (SELECT category_id FROM product_category WHERE category_name = 'Бакалея')),
    ('Куриные окорочка', 'килограмм', 200, 185, (SELECT category_id FROM product_category WHERE category_name = 'Мясо')),
    ('Картофель', 'килограмм', 40, 77, (SELECT category_id FROM product_category WHERE category_name = 'Овощи')),
    ('Морковь', 'килограмм', 30, 33, (SELECT category_id FROM product_category WHERE category_name = 'Овощи')),
    ('Репчатый лук', 'килограмм', 35, 43, (SELECT category_id FROM product_category WHERE category_name = 'Овощи')),
    ('Вермишель', 'грамм', 0.2, 329, (SELECT category_id FROM product_category WHERE category_name = 'Бакалея')),
    ('Молотый черный перец', 'по вкусу', 0, 0, (SELECT category_id FROM product_category WHERE category_name = 'Специи')),
    ('Зеленый салат', 'грамм', 0.42, 14, (SELECT category_id FROM product_category WHERE category_name = 'Овощи')),
    ('Помидоры', 'килограмм', 200, 20, (SELECT category_id FROM product_category WHERE category_name = 'Овощи')),
    ('Куриное филе', 'килограмм', 370, 110, (SELECT category_id FROM product_category WHERE category_name = 'Мясо')),
    ('Белый хлеб', 'грамм', 0.12, 280, (SELECT category_id FROM product_category WHERE category_name = 'Бакалея')),
    ('Соус "Цезарь"', 'количество штук', 60, 260, (SELECT category_id FROM product_category WHERE category_name = 'Специи')),
    ('Сливочное масло', 'грамм', 1, 748, (SELECT category_id FROM product_category WHERE category_name = 'Молоко и молочные продукты')),
    ('Чеснок', 'количество штук', 2, 46, (SELECT category_id FROM product_category WHERE category_name = 'Овощи')),
    ('Пармезан', 'грамм', 1, 310, (SELECT category_id FROM product_category WHERE category_name = 'Молоко и молочные продукты')),
    ('Вареная колбаса', 'грамм', 0.35, 236, (SELECT category_id FROM product_category WHERE category_name = 'Бакалея'));


DO $$
    DECLARE
        new_recipe_id INT;
    BEGIN
        INSERT INTO recipe (recipe_name, number_of_servings)
        VALUES ('Шарлотка', 4)
        RETURNING recipe_id INTO new_recipe_id;

        INSERT INTO recipe_product (recipe_id, product_id, number_of_product_units, product_instructions, serial_number)
        VALUES
            (new_recipe_id, (SELECT product_id FROM product WHERE product_name = 'Куриное яйцо'),
            4, 'Отделить белки от желтков.', 1),

            (new_recipe_id, (SELECT product_id FROM product WHERE product_name = 'Сахар'),
            0.25, 'Половину взбить с белками, а другую половину с желтками. Затем соединить.', 2),

            (new_recipe_id, (SELECT product_id FROM product WHERE product_name = 'Пшеничная мука'),
            0.25, 'Постепенно добавить к яичной массе.', 3),

            (new_recipe_id, (SELECT product_id FROM product WHERE product_name = 'Соль'),
            0.2, 'Добавить.', 4),

            (new_recipe_id, (SELECT product_id FROM product WHERE product_name = 'Сода'),
            0.5, 'Добавить.', 5),

            (new_recipe_id, (SELECT product_id FROM product WHERE product_name = 'Яблоко'),
            1, 'Нарезать кубиками и добавить к тесту.', 6),

            (new_recipe_id, (SELECT product_id FROM product WHERE product_name = 'Растительное масло'),
            1, 'Смазать маслом форму для запекания. Посыпать форму и выложить в нее получившееся тесто. Выпекать в ' ||
               'разогретой до 180 градусов духовке 30-40 минут.', 7);

        INSERT INTO recipe_recipe_category (recipe_id, category_id)
        VALUES
            (new_recipe_id, (SELECT category_id FROM recipe_category WHERE category_name = 'Десерт'));
    END $$;


DO $$
    DECLARE
        new_recipe_id INT;
    BEGIN
        INSERT INTO recipe (recipe_name, number_of_servings)
        VALUES ('Куриный суп', 4)
        RETURNING recipe_id INTO new_recipe_id;

        INSERT INTO recipe_product (recipe_id, product_id, number_of_product_units, product_instructions, serial_number)
        VALUES
            (new_recipe_id, (SELECT product_id FROM product WHERE product_name = 'Куриные окорочка'),
             0.75, 'Промыть, залить водой в кастрюле, поставить на сильный огонь. Когда закипит, убавить огонь до ' ||
                   'минимума.', 1),

            (new_recipe_id, (SELECT product_id FROM product WHERE product_name = 'Соль'),
             0, 'Посолить по вкусу.', 2),

            (new_recipe_id, (SELECT product_id FROM product WHERE product_name = 'Репчатый лук'),
             0.15, 'Положить целую мытую луковицу в кастрюлю, закрыть крышкой. Через 30 минут выловить.', 3),

            (new_recipe_id, (SELECT product_id FROM product WHERE product_name = 'Морковь'),
             0.15, 'Порезать 1 морковь кубиками, добавить в кастрюлю.', 4),

            (new_recipe_id, (SELECT product_id FROM product WHERE product_name = 'Картофель'),
             0.15, 'Очистить и порезать, добавить через 5 минут после моркови. Варить 10-15 минут.', 5),

            (new_recipe_id, (SELECT product_id FROM product WHERE product_name = 'Вермишель'),
             30, 'Добавить в кастрюлю, варить 15 минут.', 6),

            (new_recipe_id, (SELECT product_id FROM product WHERE product_name = 'Молотый черный перец'),
             0, 'Добавить по вкусу.', 7);

        INSERT INTO recipe_recipe_category (recipe_id, category_id)
        VALUES
            (new_recipe_id, (SELECT category_id FROM recipe_category WHERE category_name = 'Суп'));
    END $$;


DO $$
    DECLARE
        new_recipe_id INT;
    BEGIN
        INSERT INTO recipe (recipe_name, number_of_servings)
        VALUES ('Салат "Цезарь"', 4)
        RETURNING recipe_id INTO new_recipe_id;

        INSERT INTO recipe_product (recipe_id, product_id, number_of_product_units, product_instructions, serial_number)
        VALUES
            (new_recipe_id, (SELECT product_id FROM product WHERE product_name = 'Зеленый салат'),
             120, 'Промыть, просушить и нарвать на небольшие кусочки, отложить в холодильник.', 1),

            (new_recipe_id, (SELECT product_id FROM product WHERE product_name = 'Сливочное масло'),
             15, 'Положить в горячую сковородку, подождать, пока расплавиться.', 2),

            (new_recipe_id, (SELECT product_id FROM product WHERE product_name = 'Чеснок'),
             1, 'Порезать зубчик чеснока, добавить на сковороду.', 3),

            (new_recipe_id, (SELECT product_id FROM product WHERE product_name = 'Куриное филе'),
             0.3, 'Нарезать кубиками, положить в сковороду. Обжаривать на сильном огне приблизительно 10 минут ' ||
                  'до румяной корочки. Снять с огня.', 4),

            (new_recipe_id, (SELECT product_id FROM product WHERE product_name = 'Белый хлеб'),
             180, 'Порезать кубиками, обжарить до румяной корочки.', 5),

            (new_recipe_id, (SELECT product_id FROM product WHERE product_name = 'Соус "Цезарь"'),
             1, 'Достать листья салата, туда же положить обжаренную куриную грудку, помидоры, нарезанные тонкой ' ||
                'соломкой. Заправить соусом «Цезарь». Перемешать. Сверху положить получившиеся сухарики.', 6),

            (new_recipe_id, (SELECT product_id FROM product WHERE product_name = 'Пармезан'),
             20, 'Натереть сверху.', 7);

        INSERT INTO recipe_recipe_category (recipe_id, category_id)
        VALUES
            (new_recipe_id, (SELECT category_id FROM recipe_category WHERE category_name = 'Салат'));
    END $$;


DO $$
    DECLARE
        new_recipe_id INT;
    BEGIN
        INSERT INTO recipe (recipe_name, number_of_servings)
        VALUES ('Яичница с колбасой и помидорами', 1)
        RETURNING recipe_id INTO new_recipe_id;

        INSERT INTO recipe_product (recipe_id, product_id, number_of_product_units, product_instructions, serial_number)
        VALUES
            (new_recipe_id, (SELECT product_id FROM product WHERE product_name = 'Вареная колбаса'),
             150, 'Нарезать кубиками, выложить на сковороду, обжаривать на среднем огне около 5 минут.', 1),

            (new_recipe_id, (SELECT product_id FROM product WHERE product_name = 'Помидоры'),
             0.1, 'Нарезать кубиками, добавить на сковороду. Жарить еще 3-5 минут.', 2),

            (new_recipe_id, (SELECT product_id FROM product WHERE product_name = 'Куриное яйцо'),
             2, 'Освободить место для яиц, разбить в углубление и жарить несколько минут.', 3);

        INSERT INTO recipe_recipe_category (recipe_id, category_id)
        VALUES
            (new_recipe_id, (SELECT category_id FROM recipe_category WHERE category_name = 'Завтрак'));
    END $$;


DO $$
    DECLARE
        new_recipe_id INT;
    BEGIN
        INSERT INTO recipe (recipe_name, number_of_servings)
        VALUES ('Картофельное пюре', 5)
        RETURNING recipe_id INTO new_recipe_id;

        INSERT INTO recipe_product (recipe_id, product_id, number_of_product_units, product_instructions, serial_number)
        VALUES
            (new_recipe_id, (SELECT product_id FROM product WHERE product_name = 'Соль'),
            1, 'Посолить воду.', 1),

            (new_recipe_id, (SELECT product_id FROM product WHERE product_name = 'Картофель'),
            1, 'Очистить, порезать на большие куски, положить в кастрюлю.  Вода должна покрывать весь картофель. ' ||
               'Довести до кипения, потом убавить огонь и варить 20-30 минут, пока картошка не станет мягкой. ' ||
               'Слить воду.', 2),

            (new_recipe_id, (SELECT product_id FROM product WHERE product_name = 'Сливочное масло'),
            42, 'Растопить в другой кастрюле на медленном огне, добавить в картошку и размять их вместе.', 3),

            (new_recipe_id, (SELECT product_id FROM product WHERE product_name = 'Молоко'),
            0.2, 'Разогреть. Когда масло полностью впитается, медленно вливать молоко, все время помешивая смесь ' ||
                 'лопаткой.', 4);

        INSERT INTO recipe_recipe_category (recipe_id, category_id)
        VALUES
            (new_recipe_id, (SELECT category_id FROM recipe_category WHERE category_name = 'Гарнир')),
        (new_recipe_id, (SELECT category_id FROM recipe_category WHERE category_name = 'Вегетарианское блюдо'));
    END $$;


DO $$
    DECLARE
        new_recipe_id INT;
    BEGIN
        INSERT INTO recipe (recipe_name, number_of_servings)
        VALUES ('Драники', 4)
        RETURNING recipe_id INTO new_recipe_id;

        INSERT INTO recipe_product (recipe_id, product_id, number_of_product_units, product_instructions, serial_number)
        VALUES
            (new_recipe_id, (SELECT product_id FROM product WHERE product_name = 'Картофель'),
            0.5, 'Почистить, тщательно вымыть, натереть на мелкой терке.', 1),

            (new_recipe_id, (SELECT product_id FROM product WHERE product_name = 'Репчатый лук'),
            0.06, 'Аналогично измельчить половину луковицы.', 2),

            (new_recipe_id, (SELECT product_id FROM product WHERE product_name = 'Куриное яйцо'),
            1, 'Добавить в луково-картофельную смесь.', 3),

            (new_recipe_id, (SELECT product_id FROM product WHERE product_name = 'Пшеничная мука'),
            0, 'Добавить по вкусу.', 4),

            (new_recipe_id, (SELECT product_id FROM product WHERE product_name = 'Молотый черный перец'),
            0, 'Добавить по вкусу.', 5),

            (new_recipe_id, (SELECT product_id FROM product WHERE product_name = 'Растительное масло'),
            1, 'Разогреть масло на сковородке. Выложить тесто для драников, жарить до румяной корочки.', 6);

        INSERT INTO recipe_recipe_category (recipe_id, category_id)
        VALUES
            (new_recipe_id, (SELECT category_id FROM recipe_category WHERE category_name = 'Завтрак')),
            (new_recipe_id, (SELECT category_id FROM recipe_category WHERE category_name = 'Вегетарианское блюдо'));
    END $$;


DO $$
    DECLARE
        new_recipe_id INT;
    BEGIN
        INSERT INTO recipe (recipe_name, number_of_servings)
        VALUES ('Блины', 4)
        RETURNING recipe_id INTO new_recipe_id;

        INSERT INTO recipe_product (recipe_id, product_id, number_of_product_units, product_instructions, serial_number)
        VALUES
            (new_recipe_id, (SELECT product_id FROM product WHERE product_name = 'Куриное яйцо'),
            2, 'Разбить в глубокую миску.', 1),

            (new_recipe_id, (SELECT product_id FROM product WHERE product_name = 'Сахар'),
            0.05, 'Добавить 2-3 ложки.', 2),

            (new_recipe_id, (SELECT product_id FROM product WHERE product_name = 'Соль'),
            0, 'Добавить по вкусу. Взбить смесь при помощи венчика или миксера.', 3),

            (new_recipe_id, (SELECT product_id FROM product WHERE product_name = 'Молоко'),
            0.7, 'Добавить, хорошо взбить смесь.', 4),

            (new_recipe_id, (SELECT product_id FROM product WHERE product_name = 'Пшеничная мука'),
            0.3, 'Просеять, добавлять небольшими порциями, хорошо взбивая блинное тесто венчиком, чтобы не ' ||
                 'было комков.', 5),

            (new_recipe_id, (SELECT product_id FROM product WHERE product_name = 'Растительное масло'),
            1, 'Добавить 2-3 ложки, перемешать. Далее налить на разогретую сковороду 1 ложку и жарить блины, с одной ' ||
               'стороны 1-2 минуты, с другой еще полминуты.', 6);

        INSERT INTO recipe_recipe_category (recipe_id, category_id)
        VALUES
            (new_recipe_id, (SELECT category_id FROM recipe_category WHERE category_name = 'Завтрак')),
            (new_recipe_id, (SELECT category_id FROM recipe_category WHERE category_name = 'Десерт'));
    END $$;