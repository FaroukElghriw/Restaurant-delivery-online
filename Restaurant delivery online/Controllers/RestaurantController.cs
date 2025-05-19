using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Restaurant_delivery_online.Models;
using Restaurant_delivery_online.Services;

namespace Restaurant_delivery_online.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class RestaurantController : ControllerBase
    {
        private readonly IRestaurantService _restaurantService;

        public RestaurantController(IRestaurantService restaurantService)
        {
            _restaurantService = restaurantService;
        }
        [HttpGet("city/{city}")]
        public async Task<ActionResult<IEnumerable<Restaurant>>> GetRestaurantsByCity(string city)
        {
            var restaurants = await _restaurantService.GetRestaurantsByCity(city);
            return Ok(restaurants);
        }
        [HttpGet("{id}/menu")]
        public async Task<ActionResult<Restaurant>> GetRestaurantMenu(int id)
        {
            var restaurant = await _restaurantService.GetRestaurantMenu(id);
            if (restaurant == null)
                return NotFound();
            return Ok(restaurant);
        }
        [HttpPost("order")]

        public async Task<ActionResult<Order>> PlaceOrder([FromBody] Order order)
        {
            if (order.Items == null || !order.Items.Any())
                return BadRequest("At least one item must be selected");

            var createdOrder = await _restaurantService.PlaceOrder(order);
            return CreatedAtAction(nameof(PlaceOrder), new { id = createdOrder.Id }, createdOrder);
        }


    }
}
