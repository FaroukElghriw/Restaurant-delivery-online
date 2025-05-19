using Microsoft.EntityFrameworkCore;
using Restaurant_delivery_online.Data;
using Restaurant_delivery_online.Models;

namespace Restaurant_delivery_online.Services
{
    public class RestaurantService : IRestaurantService
    {
        private readonly RestaurantContext _restaurantContext;

        public RestaurantService(RestaurantContext restaurantContext)
        {
            _restaurantContext = restaurantContext;
        }

        public async Task<Restaurant> GetRestaurantMenu(int restaurantId)
        {
            return await _restaurantContext.Restaurants
                .Include(r => r.MenuItems)
                .FirstOrDefaultAsync(r => r.Id == restaurantId);
        }

        public async Task<IEnumerable<Restaurant>> GetRestaurantsByCity(string city)
        {
            return  await  _restaurantContext.Restaurants
                .Where(r => r.City.ToLower() == city.ToLower())
                .ToListAsync();
        }

        public async Task<Order> PlaceOrder(Order order)
        {
            order.OrderDate = DateTime.Now;
            order.TotalPrice = await CalculateTotalPrice(order);

            _restaurantContext.Orders.Add(order);
            await _restaurantContext.SaveChangesAsync();
            return order;
        }
        private async Task<decimal> CalculateTotalPrice(Order order)
        {
            decimal total = 0;
            foreach (var item in order.Items)
            {
                var menuItem = await _restaurantContext.MenuItems
                    .FirstOrDefaultAsync(m => m.Id == item.MenuItemId);
                total += menuItem.Price * item.Quantity;
            }
            return total;
        }
    }
}
