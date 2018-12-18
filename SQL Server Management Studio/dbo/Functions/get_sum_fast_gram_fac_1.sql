CREATE FUNCTION get_sum_fast_gram_fac(@n int, @m int = 1)
RETURNS @res table
(
Fats_grams_per_100_grams int
)
AS
BEGIN
	SET @m *= @n
	SET @n -= 1
	IF @n > 0
		INSERT INTO @res (Fats_grams_per_100_grams) SELECT * FROM get_sum_fast_gram_fac(@n, @m)
	IF @n = 0
		INSERT INTO @res (Fats_grams_per_100_grams) SELECT Fats_grams_per_100_grams + @m AS new FROM cakes
		RETURN
END