// <Summary>Code behind for pricewatch tab</Summary>
// <Author>Jeroen Roovers</Author>
namespace Project
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web.UI.WebControls;

    public partial class Pricewatch : System.Web.UI.Page
    {
        /// <summary>
        /// Databasemanager needs refactoring
        /// </summary>
        private DatabaseManager dbm = new DatabaseManager();

        /// <summary>
        /// Page Load Event
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Page_Load(object sender, EventArgs e)
        {
            this.HideAllTheThings();
            if (this.CheckQueryString())
            {
                this.LoadProductDetails();
            }
        }

        /// <summary>
        /// Hides the product specification div
        /// </summary>
        private void HideAllTheThings()
        {
            this.ProductSection.Visible = false;
        }

        /// <summary>
        /// Checks if query string has valid values
        /// </summary>
        /// <returns></returns>
        private bool CheckQueryString()
        {
            if (Request.QueryString["product"] != null)
            {
                int i = 0;
                if (int.TryParse(Request.QueryString["product"].ToString(), out i))
                {
                    this.Session["productid"] = i;
                    return true;
                }
            }
            return false;
        }

        /// <summary>
        /// Loads the details of a product into the product specification div
        /// </summary>
        private void LoadProductDetails()
        {
            int productid = Convert.ToInt32(Session["productid"].ToString());
            Product product = this.dbm.GetProductByID(productid);
            if (product != null)
            {
                this.img_Product.ImageUrl = product.PhotoURL;
                this.lbl_ProductName.Text = product.Name;
                this.lbl_ProductMinPrice.Text = product.LowestPrice.ToString("C");
                this.lbl_ProductSpecs.Text = product.DescriptionContent;
                this.ProductSection.Visible = true;

                if (Session["isLoggedIn"].ToString() == "true")
                {
                    this.btn_WriteNewReview.Visible = true;
                }
                else
                {
                    this.btn_WriteNewReview.Visible = false;
                }

                Session.Add("lastProduct", product);

                if (product.ShopAmount > 0)
                {
                    foreach (Price p in product.Pricing.OrderBy(x => x.Value).ToList())
                    {
                        TableRow foo = new TableRow();
                        TableCell[] cells = new TableCell[3] { new TableCell(), new TableCell(), new TableCell() };

                        HyperLink shoplink = new HyperLink();
                        shoplink.Text = p.AssociatedShop.Name;
                        shoplink.NavigateUrl = "#";
                        cells[0].Controls.Add(shoplink);
                        cells[0].CssClass = "ShopName";
                        cells[1].Text = "<a href=\"http://" + p.AssociatedShop.WebsiteURL + "\"\">link naar site</a>";
                        cells[1].CssClass = "ShopLink";
                        HyperLink pricelink = new HyperLink();
                        pricelink.CssClass = "acceptbutton";
                        pricelink.NavigateUrl = "#";
                        pricelink.Text = p.Value.ToString("C");
                        cells[2].Controls.Add(pricelink);
                        cells[2].CssClass = "ShopPrice";

                        foo.Cells.AddRange(cells);
                        this.table_ProductPrices.Rows.Add(foo);
                    }
                }
                else
                {
                    TableRow foo = new TableRow();
                    TableCell foobar = new TableCell();
                    foobar.CssClass = "ProDetNoPrices";
                    foobar.Text = "<h3>Sorry, er zijn geen prijzen bekend</h3>";
                    foo.Cells.Add(foobar);
                    this.table_ProductPrices.Rows.Add(foo);
                }
            }
        }

        /// <summary>
        /// Event for Search click
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Btn_Search_Click(object sender, EventArgs e)
        {
            this.HideAllTheThings();

            List<Product> results = this.dbm.GetProductsByName(this.tbox_Search.Text);
            if (results.Count > 0)
            {
                foreach (Product p in results)
                {
                    string navigateurl = "pricewatch.aspx?product=" + p.ID;
                    TableRow newrow = new TableRow();
                    TableCell photocell = new TableCell();
                    TableCell titlecell = new TableCell();
                    TableCell pricecell = new TableCell();
                    photocell.CssClass = "prothumbcell";
                    titlecell.CssClass = "protitlecell";
                    pricecell.CssClass = "propricecell";

                    Image thumbnail = new Image();
                    thumbnail.ImageUrl = p.PhotoURL;
                    thumbnail.CssClass = "productthumbnail";
                    photocell.Controls.Add(thumbnail);

                    HyperLink title = new HyperLink();
                    title.CssClass = "producttitle";
                    title.NavigateUrl = navigateurl;
                    title.Text = p.Name;
                    titlecell.Controls.Add(title);

                    HyperLink minprice = new HyperLink();
                    HyperLink storecount = new HyperLink();
                    if (p.LowestPrice == 0)
                        minprice.Text = "Geen prijzen";
                    else
                        minprice.Text = p.LowestPrice.ToString("C");
                    minprice.ToolTip = "Laagste prijs voor " + p.Name;
                    minprice.CssClass = "priceshops";
                    minprice.NavigateUrl = navigateurl;
                    storecount.Text = p.ShopAmount + " prijzen >";
                    storecount.CssClass = "priceshops acceptbutton";
                    storecount.NavigateUrl = navigateurl;
                    pricecell.Controls.Add(minprice);
                    pricecell.Controls.Add(storecount);

                    newrow.Cells.Add(photocell);
                    newrow.Cells.Add(titlecell);
                    newrow.Cells.Add(pricecell);

                    this.table_SearchResults.Rows.Add(newrow);
                }
                this.SearchResultsSection.Visible = true;
            }
        }

        /// <summary>
        /// Event for Read Reviews click
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Btn_UserReviews_Click(object sender, EventArgs e)
        {
            this.Session["WhyDidYouCome"] = "read";
            this.Response.Redirect("productreview.aspx");
        }

        /// <summary>
        /// Event for Write Review click
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Btn_WriteNewReview_Click(object sender, EventArgs e)
        {
            this.Session["WhyDidYouCome"] = "write";
            this.Response.Redirect("productreview.aspx");
        }

        /// <summary>
        /// Send comment. Moved to productreview.aspx
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Btn_SendComment_Click(object sender, EventArgs e)
        {

        }
    }
}