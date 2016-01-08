// <Summary>Register Tab</Summary>
// <Author>Jeroen Roovers</Author>
namespace Project
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.Linq;
    using System.Web;
    using System.Web.UI;
    using System.Web.UI.WebControls;

    public partial class Register : System.Web.UI.Page
    {

        private DatabaseManager dbm = new DatabaseManager();
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void Btn_Register_Click(object sender, EventArgs e)
        {
            string newusername = this.tbox_Username.Text;
            string newemail = this.tbox_email.Text;
            string newpassword = this.tbox_Password.Text;

            if (this.DoCheckInput(newusername, newemail, newpassword))
            {
                if (this.CheckIfUNiqueEmail(newemail))
                {
                    if (this.CheckIfUniqueUsername(newusername))
                    {
                        this.lbl_ErrorMessage.Text = string.Empty;
                        this.lbl_ErrorMessage.CssClass = "hidden";
                        UserAccount toadd = new UserAccount(newusername, newemail, newpassword);
                        this.CreateAccount(toadd);
                        this.Response.Redirect("login.aspx?email=" + newemail);
                    }
                    else
                    {
                        this.lbl_ErrorMessage.Text = "Deze gebruikersnaam wordt al gebruikt door een andere gebruiker.";
                        this.lbl_ErrorMessage.CssClass = "errormessage";
                    }
                }
                else
                {
                    this.lbl_ErrorMessage.Text = "Dit email-adres wordt al gebruikt voor een account.";
                    this.lbl_ErrorMessage.CssClass = "errormessage";
                }
            }
        }

        private bool DoCheckInput(string username, string email, string password)
        {
            var foo = new EmailAddressAttribute();

            bool ok_username = username.Length > 3;
            bool ok_email = foo.IsValid(email);
            bool ok_password = password.Length > 3;

            if (ok_username && ok_email && ok_password)
            {
                this.lbl_ErrorMessage.Text = string.Empty;
                this.lbl_ErrorMessage.CssClass = "hidden";
                return true;
            }
            else
            {
                this.lbl_ErrorMessage.Text = string.Empty;
                if (!ok_username)
                {
                    this.lbl_ErrorMessage.Text += "Gebruikersnaam lengte moet minimaal 4 karakters zijn.";
                    this.lbl_ErrorMessage.CssClass = "errormessage";
                }
                if (!ok_email)
                {
                    this.lbl_ErrorMessage.Text += "<br>Email is geen geldig emailadres.";
                    this.lbl_ErrorMessage.CssClass = "errormessage";
                }
                if (!ok_password)
                {
                    this.lbl_ErrorMessage.Text += "<br>Wachtwoord lengte moet minimaal 4 karakters zijn.";
                    this.lbl_ErrorMessage.CssClass = "errormessage";
                }
                return false;
            }
        }

        private bool CheckIfUniqueUsername(string username)
        {
            return this.dbm.CheckUsernameUnique(username);
        }

        private bool CheckIfUNiqueEmail(string email)
        {
            return this.dbm.CheckEmailUnique(email);
        }

        private void CreateAccount(UserAccount user)
        {
            this.dbm.AddUser(user);
        }
    }
}