namespace Project
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.Linq;
    using System.Web;
    using System.Web.UI;
    using System.Web.UI.WebControls;

    public partial class Login : System.Web.UI.Page
    {
        DatabaseManager dbm = new DatabaseManager();
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btn_Login_Click(object sender, EventArgs e)
        {
            if(this.DoCheckInput(tbox_Username.Text, tbox_Password.Text))
            {
                if(dbm.AuthenticateUser(tbox_Username.Text, tbox_Password.Text))
                {
                    LoadUser();
                    Response.Redirect("default.aspx");
                }
                else
                {
                    AuthenticationFailed();
                }
            }
        }

        private bool DoCheckInput(string email, string password)
        {
            var foo = new EmailAddressAttribute();

            if(foo.IsValid(email))
            {
                if(password.Length > 3)
                {
                    lbl_ErrorMessage.CssClass = "hidden";
                    return true;
                }
                lbl_ErrorMessage.Text = "*Wachtwoord lengte moet minimaal 4 karakters zijn";
                lbl_ErrorMessage.CssClass = "errormessage";
            }
            else
            {
                if (password.Length > 3)
                {
                    lbl_ErrorMessage.Text = "*Ongeldig emailadres opgegeven";
                    lbl_ErrorMessage.CssClass = "errormessage";
                }
                else
                {
                    lbl_ErrorMessage.Text = "*Ongeldig emailadres opgegeven en wachtwoord moet minimaal 4 tekens lang zijn";
                    lbl_ErrorMessage.CssClass = "errormessage";
                }

            }
            return false;
        }

        private void AuthenticationFailed()
        {
            lbl_ErrorMessage.Text = "*Iets ging mis bij het authenticeren!";
            lbl_ErrorMessage.CssClass = "errormessage";
        }

        private void LoadUser()
        {
            UserCache.UpdateCache();
            UserAccount foo = UserCache.Users.Find(x => x.Email.ToLower() == tbox_Username.Text.ToLower());
            Session["isLoggedIn"] = "true";
            Session["userID"] = foo.ID;
            Session["userEmail"] = foo.Email;
            Session["userAccountName"] = foo.AccountName;
            Session["userGivenMame"] = foo.GivenName;
        }
    }
}