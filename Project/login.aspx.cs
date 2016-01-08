// <Summary>login Tab</Summary>
// <Author>Jeroen Roovers</Author>
namespace Project
{
    using System;

    public partial class Login : System.Web.UI.Page
    {
        #region Fields
        private LoginManager mng = new LoginManager();
        #endregion

        #region Load Event
        protected void Page_Load(object sender, EventArgs e)
        {
            this.SetURLWithEmail();
        }
        #endregion;

        #region Methods
        /// <summary>
        /// Login button clicked
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Btn_Login_Click(object sender, EventArgs e)
        {
            if (this.DoCheckInput(this.tbox_Username.Text, this.tbox_Password.Text))
            {
                UserAccount loginuser = null;
                if (this.mng.AuthenticateUser(this.tbox_Username.Text, this.tbox_Password.Text, out loginuser))
                {
                    this.Session["isLoggedIn"] = "true";
                    this.Session["currentUser"] = loginuser;
                    this.Session.Timeout = 1440;
                    Response.Redirect("default.aspx");
                }
                else
                {
                    this.AuthenticationFailed();
                }
            }
        }
        
        /// <summary>
        /// Check user input for correctness
        /// </summary>
        /// <param name="email">email input</param>
        /// <param name="password">password input</param>
        /// <returns>True if valid</returns>
        private bool DoCheckInput(string email, string password)
        {
            string errormessage = string.Empty;
            if (!this.mng.CheckIfInputValid(email, password, out errormessage))
            {
                this.lbl_ErrorMessage.Text = errormessage;
                this.lbl_ErrorMessage.Visible = true;
                return false;
            }
            return true;
        }

        /// <summary>
        /// Sets labels if input was valid but no match in database.
        /// </summary>
        private void AuthenticationFailed()
        {
            this.lbl_ErrorMessage.Text = "*Combinatie van email en wachtwoord is onbekend!";
            this.lbl_ErrorMessage.Visible = true;
        }

        /// <summary>
        /// Sets the login textbox text if redirected from register
        /// </summary>
        private void SetURLWithEmail()
        {
            if (Request.QueryString["email"] != null)
            {
                this.tbox_Username.Text = Request.QueryString["email"];
            }
        }
        #endregion
    }
}