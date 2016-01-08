// <Summary>Code behind for Default webpage </Summary>
// <Author>Jeroen Roovers</Author>

namespace Project
{
    using System;
    using System.Collections.Generic;
    using System.Web.UI.WebControls;

    public partial class Default : System.Web.UI.Page
    {
        #region Fields
        private DefaultManager dm = new DefaultManager();
        #endregion

        #region Load Event
        protected void Page_Load(object sender, EventArgs e)
        {
            this.LoadReviews();
            this.LoadNews();
        }
        #endregion

        #region Methods
        /// <summary>
        /// Fill news table
        /// </summary>
        private void LoadNews()
        {
            TableRow[] rows = this.dm.LoadNews();
            if(rows != null)
            {
                this.table_News.Rows.AddRange(rows);
            }
        }

        /// <summary>
        /// Fills review highlights
        /// </summary>
        private void LoadReviews()
        {
            List<Review> reviews = this.dm.GetReviews();

            if (reviews != null)
            {
                HyperLink[] titlelink = new HyperLink[3] { this.link_Highlight1, this.link_Highlight2, this.link_Highlight3 };
                HyperLink[] commentlinks = new HyperLink[3] { this.link_Highlight1Comments, this.link_Highlight2Comments, this.link_Highlight3Comments };
                ImageButton[] imgbuttons = new ImageButton[3] { this.img_Highlight1, this.img_Highlight2, this.img_Highlight3 };
                for (int i = 0; i < 3; i++)
                {
                    string navigateurl = $"reviews.aspx?review={reviews[i].ID}&page={reviews[i].Pages[0].PageNR}";
                    titlelink[i].Text = $"<h2>{reviews[i].Title}</h2><p>{reviews[i].SubTitle}</p>";
                    titlelink[i].NavigateUrl = navigateurl;

                    if (reviews[i].HighLight != null)
                    {
                        imgbuttons[i].ImageUrl = reviews[i].HighLight;
                    }
                    else
                    {
                        imgbuttons[i].ImageUrl = "http://placehold.it/300x150";
                    }
                    imgbuttons[i].PostBackUrl = navigateurl;

                    commentlinks[i].Text = reviews[i].CommentCount.ToString() + " reacties";
                    commentlinks[i].NavigateUrl = navigateurl + "#reacties";
                }
            }
        }
        #endregion
    }
}