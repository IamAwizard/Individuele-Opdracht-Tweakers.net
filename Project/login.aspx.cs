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
        private DatabaseManager dbm = new DatabaseManager();
        protected void Page_Load(object sender, EventArgs e)
        {
            if(Request.QueryString["email"] != null)
            {
                tbox_Username.Text = Request.QueryString["email"];
            }
        }

        protected void Btn_Login_Click(object sender, EventArgs e)
        {
            if(this.DoCheckInput(this.tbox_Username.Text, this.tbox_Password.Text))
            {
                if(this.dbm.AuthenticateUser(this.tbox_Username.Text, this.tbox_Password.Text))
                {
                    this.LoadUser();
                    Response.Redirect("default.aspx");
                }
                else
                {
                    this.AuthenticationFailed();
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
                    this.lbl_ErrorMessage.CssClass = "hidden";
                    return true;
                }
                this.lbl_ErrorMessage.Text = "*Wachtwoord lengte moet minimaal 4 karakters zijn";
                this.lbl_ErrorMessage.CssClass = "errormessage";
            }
            else
            {
                if (password.Length > 3)
                {
                    this.lbl_ErrorMessage.Text = "*Ongeldig emailadres opgegeven";
                    this.lbl_ErrorMessage.CssClass = "errormessage";
                }
                else
                {
                    this.lbl_ErrorMessage.Text = "*Ongeldig emailadres opgegeven en wachtwoord moet minimaal 4 tekens lang zijn";
                    this.lbl_ErrorMessage.CssClass = "errormessage";
                }

            }
            return false;
        }

        private void AuthenticationFailed()
        {
            this.lbl_ErrorMessage.Text = "*Combinatie van email en wachtwoord is onbekend!";
            this.lbl_ErrorMessage.CssClass = "errormessage";
        }

        private void LoadUser()
        {
            UserCache.UpdateCache();
            UserAccount foo = UserCache.Users.Find(x => x.Email.ToLower() == tbox_Username.Text.ToLower());
            this.Session["isLoggedIn"] = "true";
            this.Session["userID"] = foo.ID;
            this.Session["userEmail"] = foo.Email;
            this.Session["userAccountName"] = foo.AccountName;
            this.Session["userGivenMame"] = foo.GivenName;
        }
    }
}