// <Summary>Logout page to abandon session</Summary>
// <Author>Jeroen Roovers</Author>
namespace Project
{
    using System;

    public partial class Logout : System.Web.UI.Page
    {

        protected void Page_Load(object sender, EventArgs e)
        {
            if ((string)Session["isLoggedIn"] == "true")
            {
                Session.Abandon();
            }
            else
            {
                this.LogoutHeader.InnerHtml = "Er is niemand om uit te loggen!";
            }
            Response.AddHeader("REFRESH", "5;URL=Default.aspx");
        }
    }
}