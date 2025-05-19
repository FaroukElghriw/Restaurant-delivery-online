using Restaurant_delivery_online.Models;

namespace Restaurant_delivery_online.Services
{
    public interface IRestaurantService
    {
        Task<IEnumerable<Restaurant>> GetRestaurantsByCity(string city);
        Task<Restaurant> GetRestaurantMenu(int restaurantId);
        Task<Order> PlaceOrder(Order order);
    }
}
