namespace Project
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web;
    using System.Web.UI;
    using System.Web.UI.WebControls;

    public partial class Productreview : System.Web.UI.Page
    {
        private DatabaseManager dbm = new DatabaseManager();
        private Product product;
        private UserAccount user;
        protected void Page_Load(object sender, EventArgs e)
        {
            this.HideAllTheThings();
            if (!this.FetchFields())
            {
                this.GetRidOfUser("");
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
                    this.LoadReviews();
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
                    this.GetRidOfUser("");
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

        private void LoadReviews()
        {
            this.ReviewsSection.Visible = true;
            this.CommentSection.Visible = true;
            if ((string)Session["isLoggedIn"] == "true")
            {
                this.AddCommentSection.Visible = true;
            }
        }

        private void WriteReview()
        {
            if (this.Session["currentUser"] != null)
            {
                this.lbl_ProductMinPrice.Text = this.product.LowestPrice.ToString("C");
                this.lbl_ProductName.Text = this.product.Name;
                this.lbl_ProductSpecs.Text = this.product.DescriptionContent;
                this.lbl_UserName.Text = this.user.AccountName;
                this.img_Product.ImageUrl = this.product.PhotoURL;
                this.ProductSection.Visible = true;
                this.AddReviewSection.Visible = true;

            }
        }

        protected void btn_SubmitReview_Click(object sender, EventArgs e)
        {
            if (this.CheckNessecaryFields())
            {
                UserReview foo;
                if (tbox_Reviewcontent.Text == string.Empty)
                {
                    foo = new UserReview(0, this.product.ID, this.user.ID, DateTime.Now, this.tbox_Summary.Text, this.rbl_Rating.SelectedIndex + 1);
                }
                else
                {
                    foo = new UserReview(0, this.product.ID, user.ID, DateTime.Now, this.tbox_Summary.Text, tbox_Reviewcontent.Text, rbl_Rating.SelectedIndex + 1);
                }
                this.dbm.AddUserReview(foo);
                Response.Redirect("pricewatch.aspx?product=" + product.ID);
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
    }
}