// <Summary>Represents a news object from the database</Summary>
// <Author>Jeroen Roovers</Author>

namespace Project
{
    using System;

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
        }

        public News(int id, string title, DateTime date)
        {
            this.ID = id;
            this.Title = title;
            this.Date = date;
            this.Content = "Nieuws met ID " + this.ID + ": heeft geen content";
        }

        // Properties
        public int ID { get; private set; }
        public int CommentCount { get; set; }
        public string Title { get; set; }
        public DateTime Date { get; set; }
        public string Content { get; set; }
        public string Category { get; set; }
        // Methods
    }
}