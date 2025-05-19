namespace Restaurant_delivery_online.Models
{
    public class MenuItem:BaseModel
    {
        public string Name { get; set; }
        public decimal Price { get; set; }
        public int RestaurantId { get; set; }
        

    }
}
