// <Summary>Represents a useraccount object from the database</Summary>
// <Author>Jeroen Roovers</Author>

namespace Project
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web;
    public class UserAccount
    {
        // Fields

        // Constructor
        public UserAccount(int id, string accountname, string password, string email, string givenname, string photo, DateTime dateofbirth)
        {
            this.ID = id;
            this.AccountName = accountname;
            this.Password = password;
            this.Email = email;
            this.GivenName = givenname;
            this.Photo = photo;
            this.DateOfBirth = dateofbirth;
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