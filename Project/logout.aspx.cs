using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Project
{
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
                LogoutHeader.InnerHtml = "Er is niemand om uit te loggen!";
            }
            Response.AddHeader("REFRESH", "5;URL=Default.aspx");
        }
    }
}