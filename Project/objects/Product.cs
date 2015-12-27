// <Summary>Represents a product object from the database</Summary>
// <Author>Jeroen Roovers</Author>

namespace Project
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web;

    public class Product
    {
        // Fields

        // Constructor
        public Product(int id, string name)
        {
            this.ID = id;
            this.DescriptionContent = string.Empty;
            this.PhotoURL = string.Empty;
            this.Name = name;
            this.Categories = new List<string>();
        }

        public Product(int id, string name, string descriptioncontent, string photourl)
        {
            this.ID = id;
            this.Name = name;
            this.DescriptionContent = descriptioncontent;
            this.PhotoURL = photourl;
            this.Categories = new List<string>();
        }

        // Properties
        public int ID { get; private set; }
        public string Name { get; private set; }
        public string PhotoURL { get;  set; }
        public string DescriptionContent { get; set; }
        public List<string> Categories { get; set; }

        // Methods
    }
}