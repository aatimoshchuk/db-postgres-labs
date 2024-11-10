WITH input(servings, recipe) AS (VALUES (:servings, :recipe)),

     product_costs AS (
         SELECT
             recipe.recipe_id,
             recipe.recipe_name,
             recipe.number_of_servings,
             product.product_name,
             product.measurement_unit,
             product.price_per_unit,
             recipe_product.number_of_product_units,
             input.servings,
             recipe_product.number_of_product_units / recipe.number_of_servings * input.servings AS
                               number_of_product_units_for_curr_number_of_servings,
             product.price_per_unit * recipe_product.number_of_product_units / recipe.number_of_servings *
             input.servings AS price_per_product_for_curr_number_of_servings
         FROM recipe_product
                  JOIN product ON recipe_product.product_id = product.product_id
                  JOIN recipe ON recipe_product.recipe_id = recipe.recipe_id
                  CROSS JOIN input
     ),

     recipe_costs AS (
         SELECT
             product_costs.recipe_id,
             product_costs.recipe_name,
             SUM(product_costs.price_per_product_for_curr_number_of_servings) AS "total_price"
         FROM product_costs
         GROUP BY product_costs.recipe_id, product_costs.recipe_name
     )

SELECT
    recipe_costs.recipe_name AS "Recipe",
    product_costs.product_name AS "Product",
    product_costs.measurement_unit AS "Measurement unit",
    product_costs.price_per_unit AS "Price per unit",
    product_costs.number_of_product_units_for_curr_number_of_servings AS
        "Number of product units",
    product_costs.price_per_product_for_curr_number_of_servings AS
        "Price per product",
    recipe_costs.total_price AS "Total price"
FROM recipe_costs
         JOIN product_costs ON recipe_costs.recipe_id = product_costs.recipe_id
         CROSS JOIN input
WHERE recipe_costs.recipe_id = (SELECT recipe_id FROM recipe_costs WHERE recipe_costs.recipe_name = input.recipe)
ORDER BY recipe_costs.recipe_id;
