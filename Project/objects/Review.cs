// <Summary>Represents a review object from the database</Summary>
// <Author>Jeroen Roovers</Author>

namespace Project
{
    using System;
    using System.Collections.Generic;

    public class Review
    {
        // Fields

        // Constructor
        public Review(int id, string title, string summary, DateTime date)
        {
            this.ID = id;
            this.Title = title;
            this.Date = date;
            this.Summary = summary;
            this.CommentCount = 0;
            this.Categories = new List<string>();
            this.Pages = new List<ReviewPage>();
        }

        // Properties
        public int ID { get; private set; }
        public string Title { get; set; }
        public string SubTitle { get; set; }
        public DateTime Date { get; set; }
        public int CommentCount { get; set; }
        public string Summary { get; set; }
        public string ThumbNail { get; set; }
        public string HighLight { get; set; }

        public List<string> Categories { get; set; }
        public List<ReviewPage> Pages { get; set; }
        
        // Methods
        public bool AddPage(ReviewPage page)
        {
            if (page != null)
            {
                this.Pages.Add(page);
                return true;
            }
            return false;
        }
    }
}