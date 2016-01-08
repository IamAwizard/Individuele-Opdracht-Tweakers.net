// <Summary>Represents a product object from the database</Summary>
// <Author>Jeroen Roovers</Author>

namespace Project
{
    using System.Collections.Generic;
    using System.Linq;

    public class Product
    {
        // Fields

        // Constructor
        public Product(int id, string name, string descriptioncontent, string photourl)
        {
            this.ID = id;
            this.Name = name;
            this.DescriptionContent = descriptioncontent;
            this.PhotoURL = photourl;
            this.Categories = new List<string>();
            this.Pricing = new List<Price>();
        }

        // Properties
        public int ID { get; private set; }
        public string Name { get; private set; }
        public string PhotoURL { get;  set; }
        public string DescriptionContent { get; set; }
        public List<Price> Pricing { get; set; }
        public List<string> Categories { get; set; }
        public decimal LowestPrice { get
            {
                if (this.ShopAmount > 0)
                    return this.Pricing.Min(x => x.Value);
                else
                    return 0;
                
            } }
        public int ShopAmount { get { return this.Pricing.Count; } }

        // Methods
    }
}