namespace Project
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web;
    using System.Web.UI;
    using System.Web.UI.WebControls;

    public partial class Reviews : System.Web.UI.Page
    {
        private DatabaseManager dbm = new DatabaseManager();

        protected void Page_Load(object sender, EventArgs e)
        {
            string qstring = Request.QueryString["review"];
            if (qstring != null)
                this.LoadReview(qstring);
            else
                this.LoadLatestReviews();
        }

        private void LoadReview(string reviewid)
        {
            if ((string)Session["isLoggedIn"] != "true")
            {
                this.addcomment.Style.Add("display", "none");
            }

            string qstring = Request.QueryString["page"];
            if (qstring != null)
            {
                List<Review> reviewlist = this.dbm.GetLatestReviews();

                int id = 0;
                bool isint = int.TryParse(reviewid, out id);
                if (isint) // Continue if given review ID is an integer
                {
                    int pageid = 0;
                    bool pageisint = int.TryParse(Request.QueryString["page"].ToString(), out pageid);
                    if (pageisint) // Continue if given page ID is an integer
                    {

                        List<Comment> comments = this.dbm.GetCommentsOnReviewByReviewID(id);
                        if (comments != null) // null comments - SHOULDN'T trigger, but just in case
                        {
                            this.comments.InnerHtml = @"<h2 id=""reacties"">Reacties<small>(" + comments.Count + ")</small></h2>";
                            if (comments.Count > 0) // If there are comments, start drawing them
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
                            else //  There are no comments for this review. Show message instead.
                            {
                                this.comments.InnerHtml += @"<div class = ""geenreacties""><p>Er zijn nog geen reacties geplaatst!</p></div>";
                            }
                        }

                        Review r = this.dbm.GetReviewByID(id);
                        if (r == null) // No such Review with given ID
                        {
                            this.ReviewsArea.InnerHtml = NotFound404.GetInnerHtmlFor404("Het opgegeven ID " + id + " is niet geldig!");
                            this.comments.Style.Add("display", "none");
                            this.addcomment.Style.Add("display", "none");
                            return;
                        }
                        else // Draw page
                        {
                            if (pageid > 0 && pageid <= r.Pages.Count) // Check is review contains this page
                            {
                                this.ReviewsArea.InnerHtml = @"<div class=""newsarea""><div class=""row""><div class=""col-12 column""><a class=""titleLink"" href=""reviews.aspx?review=" + (int)r.ID + "\"><h1>" + r.Title + " - " + r.SubTitle + "</h1></a></div></div><div class=\"row\"><div class=\"col-9 column\"><p class=\"smalldate\">" + r.Date.ToLongDateString() + " " + r.Date.ToShortTimeString() + ", <a class=\"titleLink\" href=\"reviews.aspx?review=" + (int)r.ID + "&page=" + pageid + "#reacties\">" + comments.Count + " reacties</a></p>";
                                this.ReviewsArea.InnerHtml += @"<div class=""article""><h2>" + r.Pages[pageid - 1].PageTitle + "</h2>" + r.Pages[pageid - 1].Content;
                                if (pageid < r.Pages.Count)
                                {
                                    this.ReviewsArea.InnerHtml += @"<div class=""nextpagelink""><a href=""reviews.aspx?review=" + r.ID + "&page=" + (pageid + 1) + "\"><span class=\"label\">Volgende pagina</span>" + Environment.NewLine + (pageid + 1) + ". " + r.Pages[pageid].PageTitle + "</a></div>";
                                }
                                this.ReviewsArea.InnerHtml += @"<h3>Inhoudsopgave</h3><ul class=""reviewnavigation"">";
                                foreach (ReviewPage rp in r.Pages)
                                {
                                    if (pageid == rp.PageNR)
                                    {
                                        this.ReviewsArea.InnerHtml += @"<li class=""activepage""><a href=""reviews.aspx?review=" + r.ID + "&page=" + rp.PageNR + "\">" + rp.PageNR + " - " + rp.PageTitle + "</a></li>";
                                    }
                                    else
                                    {
                                        this.ReviewsArea.InnerHtml += @"<li><a href=""reviews.aspx?review=" + r.ID + "&page=" + rp.PageNR + "\">" + rp.PageNR + " - " + rp.PageTitle + "</a></li>";
                                    }
                                }
                                this.ReviewsArea.InnerHtml += "</ul></div></div></div></div>";

                            }
                            else // Page out of range of review
                            {
                                this.DisplayErrorMessage("Het opgegeven pagina-ID " + pageid + " is buiten het paginabereik van deze review!");
                            }
                        }
                    }
                    else // Page ID is not an integer
                    {
                        this.DisplayErrorMessage("Het opgegeven pagina-ID " + qstring + " is niet geldig!");
                    }
                }
                else // Review ID is not an integer
                {
                    this.DisplayErrorMessage("Het opgegeven ID " + reviewid + " is niet geldig!");
                }
            }
            else // Page ID is null - Send to page 1
            {
                Response.Redirect("reviews.aspx?review=" + reviewid + "&page=1");
            }
        }

        private void LoadLatestReviews()
        {
            List<Review> reviewlist = this.dbm.GetLatestReviews();
            this.ReviewsArea.InnerHtml = @"<div class=""col-4 column""></div><div class=""col-8 column""><table><tbody>";
            foreach (Review r in reviewlist)
            {
                this.ReviewsArea.InnerHtml += "<tr>";
                if (r.ThumbNail != null)
                {
                    this.ReviewsArea.InnerHtml += "<td class=\"thumbnail\"><a href=\"reviews.aspx?review=" + r.ID + "&page=" + r.Pages[0].PageNR + "\"><img width=\"67px\" height=\"67px\" src=\"" + r.ThumbNail + "\"/></a></td>";
                }
                else
                {
                    this.ReviewsArea.InnerHtml += "<td class=\"thumbnail\"><a href=\"reviews.aspx?review=" + r.ID + "&page=" + r.Pages[0].PageNR + "\"><img width=\"67px\" height=\"67px\" src=\"http://placehold.it/67x67\"/></a></td>";
                }
                this.ReviewsArea.InnerHtml += "<td class=\"reviewlisting\"><p class=\"reviewlistingtitle\"><a href=\"reviews.aspx?review=" + r.ID + "&page=" + r.Pages[0].PageNR + "\">" + r.Title + "</a></p><p><b>" + r.Date.ToShortDateString() + "</b> - " + r.Summary + "</p></td>";
                this.ReviewsArea.InnerHtml += "<td class=\"comments\"><a class=\"commentcounter\" href=\"reviews.aspx?review=" + r.ID + "&page=" + r.Pages[0].PageNR + "#reacties\">" + r.CommentCount + "</a></td>";
                this.ReviewsArea.InnerHtml += "</tr>";
            }
            this.addcomment.Style.Add("display", "none");
            this.ReviewsArea.InnerHtml += "</tbody></table></div>";
        }

        protected void Btn_SendComment_Click(object sender, EventArgs e)
        {
            if (this.CheckComment())
            {
                int authorid = 0;
                bool authorok = int.TryParse(Session["userID"].ToString(), out authorid);
                UserAccount author = new UserAccount(authorid, (string)Session["userAccountName"], (string)Session["userEmail"]);
                Comment foo = new Comment(DateTime.Now, author, CommentType.CommentOnReview, tbox_Comment.Text);
                int pageid = 0;
                bool pageisint = int.TryParse(Request.QueryString["page"], out pageid);
                int reviewid = 0;
                bool reviewisint = int.TryParse(Request.QueryString["review"], out reviewid);
                if (reviewisint)
                {
                    this.dbm.AddComment(foo, reviewid);
                    if (pageisint)
                    {
                        Response.Redirect("reviews.aspx?review=" + reviewid + "&page=" + pageid + "#reacties");
                    }
                    else
                    {
                        Response.Redirect("reviews.aspx?review=" + reviewid + "#reacties");
                    }
                }
            }
        }

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

        private void DisplayErrorMessage(string msg)
        {
            this.ReviewsArea.InnerHtml = NotFound404.GetInnerHtmlFor404(msg);
            this.comments.Style.Add("display", "none");
            this.addcomment.Style.Add("display", "none");
        }
    }
}