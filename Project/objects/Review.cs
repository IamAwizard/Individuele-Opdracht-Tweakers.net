// <Summary>Represents a review object from the database</Summary>
// <Author>Jeroen Roovers</Author>

namespace Project
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web;

    public class Review
    {
        // Fields

        // Constructor
        public Review(int id, string title, DateTime date)
        {
            this.ID = id;
            this.Title = title;
            this.Date = date;
            this.Categories = new List<string>();
            this.Pages = new List<ReviewPage>();
        }

        // Properties
        public int ID { get; private set; }
        public string Title { get; set; }
        public DateTime Date { get; set; }
        public List<string> Categories { get; set; }
        public List<ReviewPage> Pages { get; set; }
        
        // Methods
        public bool AddPage(ReviewPage page)
        {
            return false;
        }
    }
}