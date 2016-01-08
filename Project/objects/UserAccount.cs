// <Summary>Represents a useraccount object from the database</Summary>
// <Author>Jeroen Roovers</Author>

namespace Project
{
    using System;
    public class UserAccount
    {
        // Fields

        // Constructor
        public UserAccount(string accountname, string email, string password)
        {
            this.AccountName = accountname;
            this.Email = email;
            this.Password = password;
        }

        public UserAccount(int id, string accountname, string email, string givenname, string photo, DateTime dateofbirth)
        {
            this.ID = id;
            this.AccountName = accountname;
            this.Email = email;
            this.GivenName = givenname;
            this.Photo = photo;
            this.DateOfBirth = dateofbirth;
        }

        public UserAccount(int id, string accountname, string email)
        {
            this.ID = id;
            this.AccountName = accountname;
            this.Email = email;
            this.GivenName = "Niet Opgegeven";
            this.Photo = "C:/";
            this.DateOfBirth = DateTime.MinValue;
        }

        // Properties
        public int ID { get; private set; }
        public string AccountName { get; set; }
        public string Password { get; set; }
        public string Email { get; set; }
        public string GivenName { get; set; }
        public string Photo { get; set; }
        public DateTime DateOfBirth { get; set; } 
        
        // Methods
    }
}