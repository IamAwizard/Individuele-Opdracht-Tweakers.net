namespace Project
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web;

    public static class UserCache
    {
        // Fields
        static DatabaseManager dbm = new DatabaseManager();

        // Properties
        /// <summary>
        /// Gets cached used, does not contain passwords!
        /// </summary>
        public static List<UserAccount> Users { get; set; }

        // Methods
        public static void UpdateCache()
        {
            List<UserAccount> foo = dbm.GetUserCache();
            if(foo != null)
            {
                Users = foo;
            }
        }
    }
}