// <Summary>Logic Class for Default webpage</Summary>
// <Author>Jeroen Roovers</Author>

namespace Project
{
    using System.Collections.Generic;
    using System.Web.UI.WebControls;

    public class DefaultManager
    {
        #region Fields
        private DatabaseManager dbm;
        #endregion

        #region Constructor
        public DefaultManager()
        {
           this.dbm = new DatabaseManager();
        }
        #endregion

        #region Methods
        /// <summary>
        /// Gets a list of reviews to display in the highlights sections
        /// </summary>
        /// <returns>A list of reviews without pages</returns>
        public List<Review> GetReviews()
        {
            return this.dbm.GetLatestReviews();
        }

        /// <summary>
        /// Gets a array of table rows to insert into the news-table
        /// </summary>
        /// <returns></returns>
        public TableRow[] LoadNews()
        {
            List<News> newslist = this.dbm.GetLatestNews();
            List<TableRow> rows = new List<TableRow>();
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
                    time.Text = n.Date.ToString("dd MMM") + " - " + n.Date.ToShortTimeString();
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

                    rows.Add(tr);
                }
                return rows.ToArray();
            }
            else
            {
                return null;
            }
        }
        #endregion
    }
}