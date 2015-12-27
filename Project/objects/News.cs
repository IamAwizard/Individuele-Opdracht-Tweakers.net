// <Summary>Represents a news object from the database</Summary>
// <Author>Jeroen Roovers</Author>

namespace Project
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web;

    public class News
    {
        // Fields

        // Constructor
        public News(int id, string title, DateTime date, string content)
        {
            this.ID = id;
            this.Title = title;
            this.Date = date;
            this.Content = content;
            this.Categories = new List<string>();
        }

        public News(int id, string title, DateTime date)
        {
            this.ID = id;
            this.Title = title;
            this.Date = date;
            this.Content = "Nieuws met ID " + this.ID + ": heeft geen content";
            this.Categories = new List<string>();
        }

        // Properties
        public int ID { get; private set; }
        public string Title { get; set; }
        public DateTime Date { get; set; }
        public string Content { get; set; }
        public List<string> Categories { get; set; }
        // Methods
    }
}