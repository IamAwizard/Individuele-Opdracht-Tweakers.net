// <Summary>News Tab</Summary>
// <Author>Jeroen Roovers</Author>
namespace Project
{
    using System;
    using System.Collections.Generic;

    public partial class Nieuws : System.Web.UI.Page
    {
        #region Fields
        /// <summary>
        /// Databasemanager needs refactoring
        /// </summary>
        private DatabaseManager dbm = new DatabaseManager();
        #endregion

        #region Events
        protected void Page_Load(object sender, EventArgs e)
        {
            string qstring = Request.QueryString["news"];
            if (qstring != null)
                this.LoadArticle(qstring);
            else
                this.LoadLatestNews();
        }

        /// <summary>
        ///  Adds a comment to the newsarticle.
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Btn_SendComment_Click(object sender, EventArgs e)
        {
            if (this.CheckComment())
            {
                UserAccount author = (UserAccount)Session["currentUser"];
                if (author != null)
                {
                    Comment foo = new Comment(DateTime.Now, author, CommentType.CommentOnNews, this.tbox_Comment.Text);
                    int newsid = 0;
                    bool isint = int.TryParse(Request.QueryString["news"], out newsid);
                    if (isint)
                    {
                        this.dbm.AddComment(foo, newsid);
                        Response.Redirect("nieuws.aspx?news=" + newsid);
                    }
                }
            }
        }
        #endregion

        #region Methods
        /// <summary>
        /// Checks if your comment is valid
        /// </summary>
        /// <returns></returns>
        private bool CheckComment()
        {
            if ((string)Session["isLoggedIn"] == "true")
            {
                if (this.tbox_Comment.Text.Length < 2)
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
        /// <summary>
        /// Gets the latest news and dynamically fills the page with HTML markup
        /// </summary>
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

        /// <summary>
        /// Loads a specific article. Gets triggered when there is a query string value of news
        /// </summary>
        /// <param name="givenid"></param>
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
                List<Comment> comments = this.dbm.GetCommentsOnNewsByNewsID(newsid);
                if (comments != null)
                {
                    this.comments.InnerHtml = @"<h2 id=""reacties"">Reacties<small>(" + comments.Count + ")</small></h2>";
                    if (comments.Count > 0)
                    {
                        foreach (Comment c in comments)
                        {
                            this.comments.InnerHtml += @"<div class=""comment""><div class=""commentheader""><h3>" + c.Author.AccountName + "</h3><p class=\"smalldate\">" + c.Date.ToLongDateString() + " " + c.Date.ToShortTimeString() + "</p></div>";
                            this.comments.InnerHtml += @"<div class=""commentbody""><p>" + c.Content + "</p>";
                            if (Session["isLoggedIn"].ToString() == "true")
                            {
                                this.comments.InnerHtml += "<br><a href =\"#reageer\">Reageer</a></div></div>";
                            }
                            else
                            {
                                this.comments.InnerHtml += "<br><a href =\"login.aspx\">Log in</a> om te reageren</div></div>";
                            }

                        }
                    }
                    else
                    {
                        this.comments.InnerHtml += @"<div class = ""geenreacties""><p>Er zijn nog geen reacties geplaatst!</p></div>";
                    }
                }

                News n = this.dbm.GetNewsByID(newsid);

                if (n == null)
                {
                    this.NewsArea.InnerHtml = NotFound404.GetInnerHtmlFor404("Het opgegeven ID " + givenid + " is niet geldig!");
                    this.comments.Style.Add("display", "none");
                    this.addcomment.Style.Add("display", "none");
                    return;
                }
                else
                {
                    this.NewsArea.InnerHtml = @"<div class=""newsarea""><div class=""row""><div class=""col-12 column""><a class=""titleLink"" href=""nieuws.aspx?news=" + (int)n.ID + "\"><h1>" + n.Title + "</h1></a></div></div><div class=\"row\"><div class=\"col-9 column\"><p class=\"smalldate\">" + n.Date.ToLongDateString() + " " + n.Date.ToShortTimeString() + ", <a class=\"titleLink\" href=\"nieuws.aspx?news=" + (int)n.ID + "#reacties\">" + comments.Count + " reacties</a></p>";
                    this.NewsArea.InnerHtml += @"<div class=""article""><p>" + n.Content + "</p></div></div></div></div>";
                }
            }
            else
            {
                this.NewsArea.InnerHtml = NotFound404.GetInnerHtmlFor404("Het opgegeven ID " + givenid + " is niet geldig!");
                this.comments.Style.Add("display", "none");
                this.addcomment.Style.Add("display", "none");
            }

        }
        #endregion
    }
}