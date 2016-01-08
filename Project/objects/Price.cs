// <Summary>Represents a price object from the database</Summary>
// <Author>Jeroen Roovers</Author>

namespace Project
{
    public class Price
    {
        // Fields

        // Constructors
        public Price(int id, int shopid, int productid, decimal value)
        {
            this.ID = id;
            this.ShopID = shopid;
            this.ProductID = productid;
            this.Value = value;
        }

        // Properties
        public int ID { get; private set; }
        public int ShopID { get; set; }
        public int ProductID { get; set; }
        public decimal Value { get; set; }
        public Shop AssociatedShop { get; set; }
   
        // Methods
    }
}