using Microsoft.EntityFrameworkCore;
using Restaurant_delivery_online.Models;

namespace Restaurant_delivery_online.Data
{
    public class RestaurantContext:DbContext
    {

        public RestaurantContext(DbContextOptions<RestaurantContext> options):base(options)
        {

        }
       

        public DbSet<Restaurant> Restaurants { get; set; }
        public DbSet<MenuItem> MenuItems { get; set; }
        public DbSet<Order> Orders { get; set; }
    }


}
