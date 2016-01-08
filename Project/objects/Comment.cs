// <Summary>Represents a comment object from the database</Summary>
// <Author>Jeroen Roovers</Author>

namespace Project
{
    using System;

    public class Comment
    {
        // Fields

        // Constructor
        public Comment(DateTime date, UserAccount author, CommentType type, string content)
        {
            this.Date = date;
            this.Type = type;
            this.Content = content;
            this.Author = author;
        }

        public Comment(int id, DateTime date, UserAccount author, CommentType type, string content)
        {
            this.ID = id;
            this.Date = date;
            this.Type = type;
            this.Content = content;
            this.Author = author;
        }

        // Properties
        public int ID { get; private set; }
        public DateTime Date { get; set; }
        public UserAccount Author { get; set; }
        public CommentType Type { get; set; }
        public string Content { get; set; }
        
        // Methods
    }
}