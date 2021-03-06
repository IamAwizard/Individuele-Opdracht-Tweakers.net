﻿// <Summary>Represents a shop object from the database</Summary>
// <Author>Jeroen Roovers</Author>

namespace Project
{
    public class Shop
    {
        // Fields

        // Constructors
        public Shop(int id, string name, string websiteurl, string descriptioncontent, string photourl)
        {
            this.ID = id;
            this.Name = name;
            this.WebsiteURL = websiteurl;
            this.DescriptionContent = descriptioncontent;
            this.PhotoURL = photourl;
        }

        // Properties
        public int ID { get; private set; }
        public string Name { get; set; }
        public string WebsiteURL { get; set; }
        public string DescriptionContent { get; set; }
        public string PhotoURL { get; set; }

        // Methods
    }
}