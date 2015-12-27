// <Summary>The databasehandler than sends the query to the database and retrievs objects from the database</Summary>
// <Author>Jeroen Roovers</Author>

namespace Project
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web;
    using Oracle.DataAccess;
    using Oracle.DataAccess.Client;

    public class DatabaseManager
    {
        // Fields
        private string connectionstring = "User Id=Tweakers;Password=Tweakers;Data Source=localhost:1521";
        private OracleConnection con;
        private OracleCommand cmd;
        private OracleDataReader dr;

        // Properties

        // Constructor
        public DatabaseManager()
        {
            this.Connect();
        }

        // Methods
        /// <summary>
        /// Connect to the database
        /// </summary>
        private void Connect()
        {
            this.con = new OracleConnection();
            this.con.ConnectionString = this.connectionstring;
            this.con.Open();
            Console.WriteLine("CONNECTION SUCCESFULL");
        }

        /// <summary>
        /// Disconnect from the database...
        /// </summary>
        public void Disconnect()
        {
            this.con.Close();
            this.con.Dispose();
        }
    }
}