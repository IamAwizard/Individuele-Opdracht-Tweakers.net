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
    }
}