// <Summary>Additional page for handling Userrevies</Summary>
// <Author>Jeroen Roovers</Author>
namespace Project
{
    using System;
    using System.Collections.Generic;

    public partial class Productreview : System.Web.UI.Page
    {
        private DatabaseManager dbm = new DatabaseManager();
        private Product product;
        private UserAccount user;
        private UserReview ur;
        protected void Page_Load(object sender, EventArgs e)
        {
            this.HideAllTheThings();
            if (!this.FetchFields())
            {
                this.GetRidOfUser(string.Empty);
            }
            else
            {
                this.DecideUserFaith();
            }
        }

        private bool FetchFields()
        {
            if (this.Session["lastProduct"] != null)
            {
                this.product = (Product)Session["lastProduct"];
                this.user = (UserAccount)Session["currentUser"];
                return true;
            }
            else
            {
                return false;
            }
        }

        private void DecideUserFaith()
        {
            if (this.Session["WhyDidYouCome"] != null)
            {
                string qstring = Session["WhyDidYouCome"].ToString();
                if (qstring == "read")
                {
                    this.LoadReview();
                }
                else if (qstring == "write")
                {
                    if ((string)Session["isLoggedIn"] == "true")
                    {
                        this.WriteReview();
                    }
                    else
                    {
                        this.GetRidOfUser("Het is je gelukt om een functie te gebruiken die alleen bedoeld is voor ingelogde gebruikers zonder ingelogd te zijn! Gefeliciteerd!");
                    }
                }
                else
                {
                    this.GetRidOfUser(string.Empty);
                }
            }
        }

        private void GetRidOfUser(string extramsg)
        {
            this.ReviewsSection.Visible = true;
            this.ReviewsSection.InnerHtml = NotFound404.GetInnerHtmlFor404("Je kunt hier alleen komen als je onlangs een product hebt bekeken in de pricewatch! Je wordt in 10 seconden door gestuurd naar de hoofdpagina..." + extramsg);
            Response.AddHeader("REFRESH", "10;URL=Default.aspx");
        }

        private void HideAllTheThings()
        {
            this.AddCommentSection.Visible = false;
            this.AddReviewSection.Visible = false;
            this.CommentSection.Visible = false;
            this.ProductSection.Visible = false;
            this.ReviewsSection.Visible = false;
        }

        private void LoadReview()
        {
            string qstring = string.Empty;
            if (Request.QueryString["review"] != null)
            {
                qstring = Request.QueryString["review"].ToString();
            }
            List<UserReview> reviews = this.dbm.GetUserReviews(this.product.ID);
            if (qstring != string.Empty)
            {
                int reviewid = 0;
                bool isint = int.TryParse(qstring, out reviewid);
                if (isint)
                {
                    this.LoadSingleReview(reviewid);
                }
            }
            else
            {
                if (reviews.Count > 0)
                {
                    this.LoadProductSection();
                    this.RepeaterReview.DataSource = reviews;
                    this.RepeaterReview.DataBind();
                    this.ReviewsSection.Visible = true;
                }
            }
        }

        private void LoadSingleReview(int reviewid)
        {
            this.ur = this.dbm.GetUserReviewByID(reviewid);
            if (this.ur != null)
            {
                this.CommentSection.Visible = true;
                if (Session["isLoggedIn"].ToString() == "true")
                {
                    this.AddCommentSection.Visible = true;
                }
                List<Comment> comments = this.dbm.GetCommentsOnNewsByUserReviewID(reviewid);
                if (comments != null)
                {
                    this.CommentSection.Visible = true;
                    this.CommentSection.InnerHtml = @"<h2 id=""reacties"">Reacties<small>(" + comments.Count + ")</small></h2>";
                    if (comments.Count > 0)
                    {
                        foreach (Comment c in comments)
                        {
                            this.CommentSection.InnerHtml += @"<div class=""comment""><div class=""commentheader""><h3>" + c.Author.AccountName + "</h3><p class=\"smalldate\">" + c.Date.ToLongDateString() + " " + c.Date.ToShortTimeString() + "</p></div>";
                            this.CommentSection.InnerHtml += @"<div class=""commentbody""><p>" + c.Content + "</p>";
                            if (Session["isLoggedIn"].ToString() == "true")
                            {
                                this.CommentSection.InnerHtml += "<br><a href =\"#reageer\">Reageer</a></div></div>";
                            }
                            else
                            {
                                this.CommentSection.InnerHtml += "<br><a href =\"login.aspx\">Log in</a> om te reageren</div></div>";
                            }
                        }
                    }
                    else
                    {
                        this.CommentSection.InnerHtml += @"<div class = ""geenreacties""><p>Er zijn nog geen reacties geplaatst!</p></div>";
                    }
                }

                List<UserReview> foolist = new List<UserReview>();
                foolist.Add(this.ur);
                this.RepeaterSingleReview.DataSource = foolist;
                this.RepeaterSingleReview.DataBind();
                this.ReviewsSection.Visible = true;
                this.CommentSection.Visible = true;

            }
            else
            {
                this.DisplayErrorMessage("Het opgegeven Review-ID " + reviewid + " is buiten het bereik van de database");
            }
        }

        private void WriteReview()
        {
            if (this.Session["currentUser"] != null)
            {
                this.LoadProductSection();
                this.lbl_UserName.Text = this.user.AccountName;
                this.AddReviewSection.Visible = true;
            }
        }

        private void LoadProductSection()
        {
            this.lbl_ProductMinPrice.Text = this.product.LowestPrice.ToString("C");
            this.lbl_ProductName.Text = this.product.Name;
            this.lbl_ProductSpecs.Text = this.product.DescriptionContent;
            this.img_Product.ImageUrl = this.product.PhotoURL;
            this.ProductSection.Visible = true;
        }

        protected void Btn_SubmitReview_Click(object sender, EventArgs e)
        {
            if (this.CheckNessecaryFields())
            {
                UserReview foo;
                if (this.tbox_Reviewcontent.Text == string.Empty)
                {
                    foo = new UserReview(0, this.product.ID, this.user.ID, DateTime.Now, this.tbox_Summary.Text, this.rbl_Rating.SelectedIndex + 1);
                }
                else
                {
                    foo = new UserReview(0, this.product.ID, this.user.ID, DateTime.Now, this.tbox_Summary.Text, this.tbox_Reviewcontent.Text, this.rbl_Rating.SelectedIndex + 1);
                }
                if (this.dbm.CheckUserReviewUnique(foo))
                {
                    this.dbm.AddUserReview(foo);
                    Response.Redirect("pricewatch.aspx?product=" + this.product.ID);
                }
                else
                {
                    this.lbl_errormessage.Visible = true;
                    this.lbl_errormessage.Text = "* Je hebt al een review voor dit product geschreven";
                }
            }
            else
            {
                this.lbl_errormessage.Visible = true;
            }

        }

        private bool CheckNessecaryFields()
        {
            if (this.rbl_Rating.SelectedIndex == -1)
            {
                return false;
            }
            if (this.tbox_Summary.Text.Length < 3)
            {
                return false;
            }
            return true;
        }

        private void DisplayErrorMessage(string msg)
        {
            this.ReviewsSection.InnerHtml = NotFound404.GetInnerHtmlFor404(msg);
            this.ReviewsSection.Visible = true;
            this.CommentSection.Visible = false;
            this.AddCommentSection.Visible = false;
        }

        protected void Btn_SendComment_Click(object sender, EventArgs e)
        {
            if(this.tbox_Comment.Text.Length > 2)
            {

                this.dbm.AddComment(new Comment(DateTime.Now, this.user, CommentType.CommentOnUserReview, this.tbox_Comment.Text), this.ur.ID);
                Response.Redirect("productreview.aspx?review=" + this.ur.ID + "#reacties");
            }
        }
    }
}