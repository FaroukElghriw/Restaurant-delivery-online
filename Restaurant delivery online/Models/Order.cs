namespace Restaurant_delivery_online.Models
{
    public class Order: BaseModel
    {
        public int RestaurantId { get; set; }
        public HashSet<OrderItem> Items { get; set; }
        public CustomerDetails Customer { get; set; }
        public decimal TotalPrice { get; set; }
        public DateTime OrderDate { get; set; }
    }
}
