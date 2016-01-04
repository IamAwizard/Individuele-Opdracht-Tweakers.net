namespace Project
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web;
    using System.Web.UI;
    using System.Web.UI.WebControls;

    public partial class Nieuws : System.Web.UI.Page
    {
        DatabaseManager dbm = new DatabaseManager();
        protected void Page_Load(object sender, EventArgs e)
        {
            string qstring = Request.QueryString["news"];
            if (qstring != null)
            {
                this.NewsArea.InnerHtml = NotFound404.GetInnerHtmlFor404("Geen nieuws artikel gevonden met ID " + qstring);
            }
            else
            {
                List<News> newslist = this.dbm.GetLatestNewsWithContent();

                foreach (News n in newslist)
                {
                    this.NewsArea.InnerHtml += @"<div class=""newsarea""><a class=""titleLink"" href=""nieuws.aspx?news=" + (int)n.ID + "\"><h1>" + n.Title + "</h1></a>";
                    this.NewsArea.InnerHtml += @"<div class=""article""><p>" + n.Content + "</p><p> <a href=\"#\">→ Reacties(" + n.CommentCount + ")</a></p></div></div>";
                }
            }
        }
    }
}