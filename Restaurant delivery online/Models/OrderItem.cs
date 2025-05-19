namespace Restaurant_delivery_online.Models
{
    public class OrderItem : BaseModel
    {
        public int MenuItemId { get; set; }
        public int Quantity { get; set; }
    }
}
