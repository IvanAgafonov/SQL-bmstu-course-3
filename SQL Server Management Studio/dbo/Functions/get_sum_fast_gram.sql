-- обычная
CREATE FUNCTION get_sum_fast_gram(@n int)
RETURNS TABLE 
AS
RETURN 
(
	SELECT Fats_grams_per_100_grams + @n AS new FROM cakes
)