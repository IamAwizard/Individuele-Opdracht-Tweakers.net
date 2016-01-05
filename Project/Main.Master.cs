// <Summary>Masterpage with header and footer</Summary>
// <Author>Jeroen Roovers</Author>

namespace Project
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web;
    using System.Web.UI;
    using System.Web.UI.WebControls;

    public partial class Main : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            UpdateMenuBar();
        }

        /// <summary>
        /// Hides the login and register button if a user is already logged in.
        /// Otherwise hides the email-label and logout button.
        /// </summary>
        private void UpdateMenuBar()
        {
            string truestring = "true";
            string falsestring = "false";
            if (this.Session["isLoggedIn"] == null)
            {
                this.Session["isLoggedIn"] = falsestring;
                hlink_menubar_UserCurrent.CssClass = "hidden";
                hlink_menubar_UserLogout.CssClass = "hidden";
            }
            else
            {
                if ((string)Session["isLoggedIn"] == truestring)
                {
                    hlink_menubar_Login.CssClass = "hidden";
                    hlink_menubar_Register.CssClass = "hidden";
                    hlink_menubar_UserCurrent.CssClass = "";
                    hlink_menubar_UserCurrent.Text = (string)Session["userAccountName"];
                    hlink_menubar_UserLogout.CssClass = "";
                }
                else
                {
                    hlink_menubar_Login.CssClass = "";
                    hlink_menubar_Register.CssClass = "";
                    hlink_menubar_UserCurrent.CssClass = "hidden";
                    hlink_menubar_UserLogout.CssClass = "hidden";
                }
            }
        }
    }
}