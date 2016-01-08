// <Summary>Logic Class for Login webpage</Summary>
// <Author>Jeroen Roovers</Author>

namespace Project
{
    using System.ComponentModel.DataAnnotations;

    public class LoginManager
    {
        #region Fields
        private DatabaseManager dbm;
        #endregion

        #region Constructor
        public LoginManager()
        {
            this.dbm = new DatabaseManager();
        }
        #endregion

        #region Methods
        /// <summary>
        /// Authenticates the user
        /// </summary>
        /// <param name="email">the email to authenticate with</param>
        /// <param name="password">The password to authenticate with</param>
        /// <param name="useraccount">If authentication is valid this is the user</param>
        /// <returns>true is success, otherwise false</returns>
        public bool AuthenticateUser(string email, string password, out UserAccount useraccount)
        {
            return this.dbm.AuthenticateUser(email, password, out useraccount);
        }
        /// <summary>
        /// Checks input for email and password
        /// </summary>
        /// <param name="email">email input</param>
        /// <param name="password">password input</param>
        /// <param name="message">this will output a error message if there is one to display</param>
        /// <returns>True if passed all checks. otherwise false</returns>
        public bool CheckIfInputValid(string email, string password, out string message)
        {
            var foo = new EmailAddressAttribute();
            message = string.Empty;

            if (foo.IsValid(email))
            {
                if (password.Length > 3)
                {

                    return true;
                }
                message = "*Wachtwoord lengte moet minimaal 4 karakters zijn";
            }
            else
            {
                if (password.Length > 3)
                {
                    message = "*Ongeldig emailadres opgegeven";
                }
                else
                {
                    message = "*Ongeldig emailadres opgegeven en wachtwoord moet minimaal 4 tekens lang zijn";
                }

            }
            return false;
        }
        #endregion
    }
}