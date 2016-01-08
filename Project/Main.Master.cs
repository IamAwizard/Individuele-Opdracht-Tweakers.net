// <Summary>Masterpage with header and footer</Summary>
// <Author>Jeroen Roovers</Author>

namespace Project
{
    using System;

    public partial class Main : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            this.UpdateMenuBar();
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
                this.hlink_menubar_UserCurrent.CssClass = "hidden";
                this.hlink_menubar_UserLogout.CssClass = "hidden";
            }
            else
            {
                if ((string)Session["isLoggedIn"] == truestring)
                {
                    this.hlink_menubar_Login.CssClass = "hidden";
                    this.hlink_menubar_Register.CssClass = "hidden";
                    this.hlink_menubar_UserCurrent.CssClass = string.Empty;
                    this.hlink_menubar_UserCurrent.Text = ((UserAccount)Session["currentUser"]).AccountName;
                    this.hlink_menubar_UserLogout.CssClass = string.Empty;
                }
                else
                {
                    this.hlink_menubar_Login.CssClass = string.Empty;
                    this.hlink_menubar_Register.CssClass = string.Empty;
                    this.hlink_menubar_UserCurrent.CssClass = "hidden";
                    this.hlink_menubar_UserLogout.CssClass = "hidden";
                }
            }
        }
    }
}