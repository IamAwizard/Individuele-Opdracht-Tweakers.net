// <Summary>Represents a reviewpage object from the database</Summary>
// <Author>Jeroen Roovers</Author>

namespace Project
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web;

    public class ReviewPage
    {
        // Fields

        // Constructor
        public ReviewPage(int id, int pagenr, string pagetitle)
        {
            this.ID = id;
            this.PageNR = pagenr;
            this.PageTitle = pagetitle;
            this.Content = "Deze reviewpagina heeft geen content";
        }

        public ReviewPage(int id, int pagenr, string pagetitle, string content)
        {
            this.ID = id;
            this.PageNR = pagenr;
            this.PageTitle = pagetitle;
            this.Content = content;
        }

        // Properties
        public int ID { get; private set; }
        public int PageNR { get; set; }
        public string PageTitle { get; set; }
        public string Content { get; set; }
        // Methods
    }
}