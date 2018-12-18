using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.SqlClient;

namespace SQL_insert
{
    class cakes_random
    {
        public Random Dish_name = new Random();
        public Random Number_servings = new Random();
        public Random Fats_grams_per_100_grams = new Random();
        public Random With_fruits = new Random();
        public Random Сooking_difficulty = new Random();

        public string[] Country = { "Russian", "French", "German", "Ukrainian",
                                "Polish", "American"};
        public string[] Type = { "pie", "cake", "tart", "charlotte", "cooky", "biscuit", "pastry" };

        public string[] difficulties = { "easy", "normal", "hard", "very hard" };

    }

    class drinks_random
    {
        public Random Drink_name = new Random();
        public Random Fast_carbs_grams_per_100_grams = new Random();
        public Random Above_average_rating = new Random();
        public Random Temperature_serving_C = new Random();
        public Random Color = new Random();

        public string[] Adjective = { "refreshing", "sweet", "thirst quenching", "carbonated",
                                "explosive", "tasty"};
        public string[] Type = { "milkshake", "juice", "tea", "coffee", "beer", "water", "soda" };

        public string[] Colors = { "orange", "yellow", "black", "red", "crimson", "white", "pink" };
    }

    class breakfast_random
    {
        public Random Dish_name = new Random();
        public Random Cooking_time = new Random();
        public Random Slow_carbs_grams_per_100_grams = new Random();
        public Random Above_average_rating = new Random();
        public Random Average_cost_rub = new Random();
        public Random drink_id = new Random();

        public string[] Country = { "Russian", "French", "German", "Ukrainian",
                                "Polish", "American"};
        public string[] Type = { "bacon and eggs", "cheese toasts", "omelette", "milk flakes", "chocolate pancakes", "porridge", "baguette with ham" };
    }

    class Program
    {
        static void Main(string[] args)
        {
            cakes_random insert_cakes = new cakes_random();
            drinks_random insert_drinks = new drinks_random();
            breakfast_random insert_breakfast = new breakfast_random();


            Console.Write( insert_cakes.Dish_name.Next(1+1));
            


            string ConnectionString = ("Server=localhost;Database=food;Trusted_Connection=True");
            using (SqlConnection MyConnection = new SqlConnection(ConnectionString))
            {
                for (int i = 1; i <= 100; i++)
                {
                    using (SqlCommand NowCommand = new SqlCommand("INSERT INTO cakes (ID, Dish_name, Number_servings, Fats_grams_per_100_grams, With_fruits, Сooking_difficulty) "
                        + "Values (" + i.ToString() + ","
                        + "'" + insert_cakes.Country[insert_cakes.Dish_name.Next(insert_cakes.Country.Length)] + " "
                        + insert_cakes.Type[insert_cakes.Dish_name.Next(insert_cakes.Type.Length)] + "'" + ","
                        + insert_cakes.Number_servings.Next(2, 6 + 1) + ","
                        + insert_cakes.Fats_grams_per_100_grams.Next(80 + 1) + ","
                        + insert_cakes.With_fruits.Next(1+1) + ","
                        + "'" + insert_cakes.difficulties[insert_cakes.Сooking_difficulty.Next(insert_cakes.difficulties.Length)] + "'" +
                        ")", MyConnection))
                    {
                        MyConnection.Open();
                        NowCommand.ExecuteNonQuery();
                        MyConnection.Close();
                    }

                    using (SqlCommand NowCommand = new SqlCommand("INSERT INTO drinks (ID, Drink_name, Fast_carbs_grams_per_100_grams, Above_average_rating, Temperature_serving_C, Color) "
                        + "Values (" + i.ToString() + ","
                        + "'" + insert_drinks.Adjective[insert_drinks.Drink_name.Next(insert_drinks.Adjective.Length)] + " "
                        + insert_drinks.Type[insert_drinks.Drink_name.Next(insert_drinks.Type.Length)] + "'" + ","
                        + insert_drinks.Fast_carbs_grams_per_100_grams.Next(80 + 1) + ","
                        + insert_drinks.Above_average_rating.Next(1 + 1) + ","
                        + insert_drinks.Temperature_serving_C.Next(10, 80 + 1) + ","
                        + "'" + insert_drinks.Colors[insert_drinks.Color.Next(insert_drinks.Colors.Length)] + "'" +
                        ")", MyConnection))
                    {
                        MyConnection.Open();
                        NowCommand.ExecuteNonQuery();
                        MyConnection.Close();
                    }
                }

                for (int i = 1; i <= 100; i++)
                {
                    //'02:15:30'
                    using (SqlCommand testCommand = new SqlCommand("INSERT INTO breakfast (ID, Dish_name, Cooking_time, Slow_carbs_grams_per_100_grams, Above_average_rating, Average_cost_rub, drink_id) "
                        + "Values (" + i.ToString() + ","
                        + "'" + insert_breakfast.Country[insert_breakfast.Dish_name.Next(insert_breakfast.Country.Length)] + " "
                        + insert_breakfast.Type[insert_breakfast.Dish_name.Next(insert_breakfast.Type.Length)] + "'" + ","
                        + "'" + insert_breakfast.Cooking_time.Next(1 + 1) + ":" + insert_breakfast.Cooking_time.Next(59 + 1) + ":" + insert_breakfast.Cooking_time.Next(59 + 1) + "'" + ","
                        + insert_breakfast.Slow_carbs_grams_per_100_grams.Next(80 + 1) + ","
                        + insert_breakfast.Above_average_rating.Next(1 + 1) + ","
                        + insert_breakfast.Average_cost_rub.Next(100, 1000 + 1) + ","
                        + insert_breakfast.drink_id.Next(100 + 1) +
                        ")", MyConnection))
                    {
                        MyConnection.Open();
                        testCommand.ExecuteNonQuery();
                        MyConnection.Close();
                    }
                }
            }
            Console.Read();
        }

    }
}

