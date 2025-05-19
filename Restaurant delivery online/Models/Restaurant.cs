using System.Collections.Generic;

namespace Restaurant_delivery_online.Models
{
    public class Restaurant : BaseModel
    {
        public string Name { get; set; }
        public string City { get; set; }
        public HashSet<MenuItem> MenuItems { get; set; }
    }
}
