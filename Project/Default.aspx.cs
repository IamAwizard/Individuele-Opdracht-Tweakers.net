// <Summary>Code behind for default webpage </Summary>
// <Author>Jeroen Roovers</Author>

namespace Project
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web;
    using System.Web.UI;
    using System.Web.UI.WebControls;

    public partial class Default : System.Web.UI.Page
    {

        private DatabaseManager dbm = new DatabaseManager();

        protected void Page_Load(object sender, EventArgs e)
        {
            this.LoadReviews();
            this.LoadNews();
        }

        private void LoadNews()
        {
            List<News> newslist = this.dbm.GetLatestNews();

            if (newslist != null)
            {
                foreach (News n in newslist)
                {
                    TableRow tr = new TableRow();

                    TableCell category = new TableCell();
                    HyperLink categorylink = new HyperLink();
                    categorylink.Text = string.Empty;
                    categorylink.ToolTip = "TODO";
                    categorylink.NavigateUrl = "#";
                    categorylink.CssClass = "categoryicon";
                    category.Controls.Add(categorylink);
                    category.CssClass = "category";

                    TableCell time = new TableCell();
                    time.Text = n.Date.ToShortTimeString();
                    time.CssClass = "timeplaced";

                    TableCell headline = new TableCell();
                    HyperLink headlinelink = new HyperLink();
                    headlinelink.Text = n.Title;
                    headlinelink.NavigateUrl = "nieuws.aspx?news=" + n.ID;
                    headline.Controls.Add(headlinelink);
                    headline.CssClass = "headline";

                    TableCell commentcount = new TableCell();
                    commentcount.CssClass = "comments";
                    HyperLink commentlink = new HyperLink();
                    commentlink.Text = n.CommentCount.ToString();
                    commentlink.CssClass = "commentcounter";
                    commentlink.NavigateUrl = "nieuws.aspx?news=" + n.ID + "#reacties";
                    commentcount.Controls.Add(commentlink);

                    tr.Cells.Add(category);
                    tr.Cells.Add(time);
                    tr.Cells.Add(headline);
                    tr.Cells.Add(commentcount);

                    this.table_News.Rows.Add(tr);
                }
            }
        }

        private void LoadReviews()
        {
            List<Review> reviews = this.dbm.GetLatestReviews();

            if (reviews != null)
            {
                if (reviews.Count > 0)
                {
                    string navigateurl = string.Format("reviews.aspx?review={0}&page={1}", reviews[0].ID, reviews[0].Pages[0].PageNR);
                    this.link_Highlight1.Text = string.Format("<h2>{0}</h2><p>{1}</p>", reviews[0].Title, reviews[0].SubTitle);
                    this.link_Highlight1.NavigateUrl = navigateurl;
                    if (reviews[0].HighLight != null)
                    {
                        this.img_Highlight1.ImageUrl = reviews[0].HighLight;
                    }
                    else
                    {
                        this.img_Highlight1.ImageUrl = "http://placehold.it/300x150";
                    }
                    this.img_Highlight1.PostBackUrl = navigateurl;

                    this.link_Highlight1Comments.Text = reviews[0].CommentCount.ToString() + " reacties";
                    this.link_Highlight1Comments.NavigateUrl = navigateurl + "#reacties";
                }
                if (reviews.Count > 1)
                {
                    string navigateurl = string.Format("reviews.aspx?review={0}&page={1}", reviews[1].ID, reviews[1].Pages[0].PageNR);
                    this.link_Highlight2.Text = string.Format("<h2>{0}</h2><p>{1}</p>", reviews[1].Title, reviews[1].SubTitle);
                    this.link_Highlight2.NavigateUrl = navigateurl;
                    if (reviews[1].HighLight != null)
                    {
                        this.img_Highlight2.ImageUrl = reviews[1].HighLight;
                    }
                    else
                    {
                        this.img_Highlight2.ImageUrl = "http://placehold.it/300x150";
                    }
                    this.img_Highlight2.PostBackUrl = navigateurl;

                    this.link_Highlight2Comments.Text = reviews[1].CommentCount.ToString() + " reacties";
                    this.link_Highlight2Comments.NavigateUrl = navigateurl + "#reacties";
                }
                if (reviews.Count > 2)
                {
                    string navigateurl = string.Format("reviews.aspx?review={0}&page={1}", reviews[2].ID, reviews[2].Pages[0].PageNR);
                    this.link_Highlight3.Text = string.Format("<h2>{0}</h2><p>{1}</p>", reviews[2].Title, reviews[2].SubTitle);
                    this.link_Highlight3.NavigateUrl = navigateurl;
                    if (reviews[2].HighLight != null)
                    {
                        this.img_Highlight3.ImageUrl = reviews[2].HighLight;
                    }
                    else
                    {
                        this.img_Highlight3.ImageUrl = "http://placehold.it/300x150";
                    }
                    this.img_Highlight3.PostBackUrl = navigateurl;

                    this.link_Highlight3Comments.Text = reviews[2].CommentCount.ToString() + " reacties";
                    this.link_Highlight3Comments.NavigateUrl = navigateurl + "#reacties";
                }
            }
        }
    }
}