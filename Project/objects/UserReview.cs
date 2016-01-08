// <Summary>Represents a userreview object from the database</Summary>
// <Author>Jeroen Roovers</Author>

namespace Project
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web;

    public class UserReview
    {
        // Fields

        // Constructor
        public UserReview(int id, int productid, int authorid, DateTime date, string summary, int rating)
        {
            this.ID = id;
            this.ProductID = productid;
            this.AuthorID = authorid;
            this.Date = date;
            this.Summary = summary;
            this.Content = string.Empty;
            this.Rating = rating;
        }

        public UserReview(int id, int productid, int authorid, DateTime date, string summary, string content, int rating)
        {
            this.ID = id;
            this.ProductID = productid;
            this.AuthorID = authorid;
            this.Date = date;
            this.Summary = summary;
            this.Content = content;
            this.Rating = rating;
        }

        public UserReview(int id, int productid, string authorname, DateTime date, string summary, int commentcount, int rating)
        {
            this.ID = id;
            this.ProductID = productid;
            this.AuthorName = authorname;
            this.Date = date;
            this.Summary = summary;
            this.CommentCount = commentcount;
            this.Rating = rating;
        }

        // Properties
        public int ID { get; private set; }
        public int ProductID { get; set; }
        public int AuthorID { get; set; }
        public DateTime Date { get; set; }
        public string Summary { get; set; }
        public string Content { get; set; }
        public int Rating { get; set; }
        public int CommentCount { get; set; }
        public string AuthorName { get; set; }
        public string LongDateString { get { return Date.ToLongDateString(); } }
        // Methods
    }
}