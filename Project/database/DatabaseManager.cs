// <Summary>The databasehandler than sends the query to the database and retrievs objects from the database</Summary>
// <Author>Jeroen Roovers</Author>

namespace Project
{
    using System;
    using System.Collections.Generic;
    using System.Data;
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
            System.Diagnostics.Debug.WriteLine("CONNECTION SUCCESFULL");
        }

        /// <summary>
        /// Disconnect from the database...
        /// </summary>
        public void Disconnect()
        {
            this.con.Close();
            this.con.Dispose();
        }

        /// <summary>
        /// Disconnect from the database...
        /// </summary>
        private void SimpleRead(string sql)
        {
            try
            {
                this.cmd = new OracleCommand();
                this.cmd.Connection = this.con;
                this.cmd.CommandText = sql;
                this.cmd.CommandType = CommandType.Text;
                this.dr = this.cmd.ExecuteReader();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine(ex.Message);
            }
        }

        public List<News> GetLatestNews()
        {
            try
            {
                this.Connect();
                List<News> returnlist = new List<News>();

                this.SimpleRead("SELECT * FROM " +
                    "(SELECT N.NIEUWSID, N.DATUM, N.TITEL, C.NAAM, COUNT(R.REACTIEID) AS AANTALREACTIES " +
                    "FROM NIEUWS N LEFT JOIN  REACTIE R ON N.NIEUWSID = R.EXTERNID AND R.REACTIETYPEID = 1, CATEGORIE C " +
                    "WHERE N.CATEGORIE = C.CATEGORIEID " +
                    "OR N.CATEGORIE IS NULL " +
                    "GROUP BY N.NIEUWSID, N.DATUM, N.TITEL, C.NAAM " +
                    "ORDER BY DATUM DESC) " +
                    "WHERE ROWNUM <= 30");

                while (this.dr.Read())
                {
                    var id = this.dr.GetInt32(0);
                    var date = this.dr.GetDateTime(1);
                    var title = this.dr.GetString(2);
                    var categorie = this.dr.GetString(3);
                    var comments = this.dr.GetDecimal(4);

                    News toadd = new News(id, title, date);
                    toadd.Category = categorie;
                    toadd.CommentCount = (int)comments;

                    returnlist.Add(toadd);
                }

                return returnlist;
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                return null;
            }
            finally
            {
                this.Disconnect();
            }
        }

        public List<News> GetLatestNewsWithContent()
        {
            try
            {
                this.Connect();
                List<News> returnlist = new List<News>();

                this.SimpleRead("SELECT * FROM " +
                                       "(SELECT N.NIEUWSID, N.DATUM, N.TITEL, C.NAAM, COUNT(R.REACTIEID) AS AANTALREACTIES " +
                                       "FROM NIEUWS N LEFT JOIN  REACTIE R ON N.NIEUWSID = R.EXTERNID AND R.REACTIETYPEID = 1, CATEGORIE C " +
                                       "WHERE N.CATEGORIE = C.CATEGORIEID " +
                                       "OR N.CATEGORIE IS NULL " +
                                       "GROUP BY N.NIEUWSID, N.DATUM, N.TITEL, C.NAAM " +
                                       "ORDER BY DATUM DESC) " +
                                       "WHERE ROWNUM <= 30");

                while (this.dr.Read())
                {
                    var id = this.dr.GetInt32(0);
                    var date = this.dr.GetDateTime(1);
                    var title = this.dr.GetString(2);
                    var categorie = this.dr.GetString(3);
                    var comments = this.dr.GetDecimal(4);

                    News toadd = new News(id, title, date);
                    toadd.Category = categorie;
                    toadd.CommentCount = (int)comments;

                    returnlist.Add(toadd);
                }

                foreach (News n in returnlist)
                {
                    this.SimpleRead("SELECT CONTENT FROM NIEUWS WHERE NIEUWSID =" + n.ID);
                    while (this.dr.Read())
                    {
                        var content = this.dr.GetString(0);

                        n.Content = content;
                    }
                }

                return returnlist;
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                return null;
            }
            finally
            {

            }
        }

        public List<UserAccount> GetUserCache()
        {
            try
            {
                this.Connect();
                List<UserAccount> returnlist = new List<UserAccount>();

                this.SimpleRead("SELECT ACCOUNTID, ACCOUNTNAAM, LOWER(EMAIL), NAAM, FOTO, GEBOORTEDATUM FROM USERACCOUNT");
                while (this.dr.Read())
                {
                    var id = this.dr.GetInt32(0);
                    var username = this.dr.GetString(1);
                    var email = this.dr.GetString(2);
                    var givenname = this.dr.GetString(3);
                    var photo = this.dr.GetString(4);
                    var dob = this.dr.GetDateTime(5);

                    UserAccount foo = new UserAccount(id, username, email, givenname, photo, dob);
                    returnlist.Add(foo);
                }
                return returnlist;
            }
            catch (Exception ex) 
            {
                System.Diagnostics.Debug.WriteLine(ex.Message);
                return null;
            }
            finally
            {
                this.Disconnect();
            }
        }

        public bool AuthenticateUser(string email, string password)
        {
            try
            {
                this.Connect();

                this.cmd = new OracleCommand();
                this.cmd.Connection = this.con;
                this.cmd.CommandText = "SELECT * FROM USERACCOUNT WHERE LOWER(email) = LOWER(:newEMAIL) AND WACHTWOORD = :newPASSWORD";
                this.cmd.Parameters.Add("newEMAIL", email);
                this.cmd.Parameters.Add("newPASSWORD", password);
                this.cmd.CommandType = CommandType.Text;
                this.dr = this.cmd.ExecuteReader();
                if(dr.HasRows)
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
            catch
            {
                return false;
            }
            finally
            {
                this.Disconnect();
            }
        }

    }
}