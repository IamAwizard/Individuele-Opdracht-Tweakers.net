// <Summary>News Tab</Summary>
// <Author>Jeroen Roovers</Author>
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
        private DatabaseManager dbm = new DatabaseManager();
        protected void Page_Load(object sender, EventArgs e)
        {
            string qstring = Request.QueryString["news"];
            if (qstring != null)
                this.LoadArticle(qstring);
            else
                this.LoadLatestNews();
        }

        private void LoadLatestNews()
        {
            List<News> newslist = this.dbm.GetLatestNewsWithContent();

            foreach (News n in newslist)
            {
                this.NewsArea.InnerHtml += @"<div class=""newsarea""><div class=""row""><div class=""col-12 column""><a class=""titleLink"" href=""nieuws.aspx?news=" + (int)n.ID + "\"><h1>" + n.Title + "</h1></a></div></div><div class=\"row\"><div class=\"col-8 column\"><p class=\"smalldate\">" + n.Date.ToLongDateString() + " " + n.Date.ToShortTimeString() + ", <a class=\"titleLink\" href=\"nieuws.aspx?news=" + (int)n.ID + "#reacties\">" + n.CommentCount + " reacties</a></p>";
                this.NewsArea.InnerHtml += @"<div class=""article""><p>" + n.Content + "</p><p><a href=\"nieuws.aspx?news=" + (int)n.ID + "#reacties\" class=\"newscommentlink\">→ Reacties(" + n.CommentCount + ")</a></p></div></div></div></div>";
                this.addcomment.Style.Add("display", "none");
            }
        }

        private void LoadArticle(string givenid)
        {
            if ((string)Session["isLoggedIn"] != "true")
            {
                this.addcomment.Style.Add("display", "none");
            }
            int newsid = 0;
            bool isint = int.TryParse(givenid, out newsid);
            if (isint)
            {
                // Comments
                List<Comment> comments = this.dbm.GetCommentsOnNewsByNewsID(newsid);
                this.comments.InnerHtml = @"<h2>Reacties<small>(" + comments.Count + ")</small></h2>";
                if (comments.Count > 0)
                {
                    foreach (Comment c in comments)
                    {
                        this.comments.InnerHtml += @"<div class=""comment""><div class=""commentheader""><h3>" + c.Author.AccountName + "</h3><p class=\"smalldate\">" + c.Date.ToLongDateString() + " " + c.Date.ToShortTimeString() + "</p></div>";
                        this.comments.InnerHtml += @"<div class=""commentbody""><p>" + c.Content + "</p><br><a href=\"#reageer\">Reageer</a></div></div>";
                    }

                }
                else
                {
                    this.comments.InnerHtml += @"<div class = ""geenreacties""><p>Er zijn nog geen reacties geplaatst!</p></div>";
                }

                // Article
                News n = this.dbm.GetNewsByID(newsid);
                this.NewsArea.InnerHtml = @"<div class=""newsarea""><div class=""row""><div class=""col-12 column""><a class=""titleLink"" href=""nieuws.aspx?news=" + (int)n.ID + "\"><h1>" + n.Title + "</h1></a></div></div><div class=\"row\"><div class=\"col-9 column\"><p class=\"smalldate\">" + n.Date.ToLongDateString() + " " + n.Date.ToShortTimeString() + ", <a class=\"titleLink\" href=\"nieuws.aspx?news=" + (int)n.ID + "#reacties\">" + comments.Count + " reacties</a></p>";
                this.NewsArea.InnerHtml += @"<div class=""article""><p>" + n.Content + "</p></div></div></div></div>";
            }

            else
            {
                this.NewsArea.InnerHtml = NotFound404.GetInnerHtmlFor404("Het opgegeven ID " + givenid + " is niet geldig!");
            }
        }

        protected void btn_SendComment_Click(object sender, EventArgs e)
        {
            if (this.CheckComment())
            {

                int authorid = 0;
                bool authorok = int.TryParse(Session["userID"].ToString(), out authorid);
                UserAccount author = new UserAccount(authorid, (string)Session["userAccountName"], (string)Session["userEmail"]);
                Comment foo = new Comment(DateTime.Now, author, CommentType.CommentOnNews, tbox_Comment.Text);
                int newsid = 0;
                bool isint = int.TryParse(Request.QueryString["news"], out newsid);
                if (isint)
                {
                    this.dbm.AddComment(foo, newsid);
                    Response.Redirect("nieuws.aspx?news=" + newsid);
                }
            }
        }

        private bool CheckComment()
        {
            if ((string)Session["isLoggedIn"] == "true")
            {
                if (tbox_Comment.Text.Length < 2)
                {
                    return false;
                }
                else
                {
                    return true;
                }
            }
            return false;
        }
    }
}