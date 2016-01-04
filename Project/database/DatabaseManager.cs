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

        /// <summary>
        /// Disconnect from the database...
        /// </summary>
        private void Read(string sql)
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
                Console.WriteLine(ex.Message);
            }
        }

        public List<News> GetLatestNews()
        {
            try
            {
                this.Connect();
                List<News> returnlist = new List<News>();

                this.Read("SELECT * FROM " +
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

                this.cmd = new OracleCommand();
                this.cmd.Connection = this.con;
                this.cmd.CommandType = CommandType.Text;
                this.cmd.CommandText = "SELECT * FROM " +
                                       "(SELECT N.NIEUWSID, N.DATUM, N.TITEL, C.NAAM, COUNT(R.REACTIEID) AS AANTALREACTIES " +
                                       "FROM NIEUWS N LEFT JOIN  REACTIE R ON N.NIEUWSID = R.EXTERNID AND R.REACTIETYPEID = 1, CATEGORIE C " +
                                       "WHERE N.CATEGORIE = C.CATEGORIEID " +
                                       "OR N.CATEGORIE IS NULL " +
                                       "GROUP BY N.NIEUWSID, N.DATUM, N.TITEL, C.NAAM " +
                                       "ORDER BY DATUM DESC) " +
                                       "WHERE ROWNUM <= 30";

                this.dr = this.cmd.ExecuteReader();

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
                    this.Read("SELECT CONTENT FROM NIEUWS WHERE NIEUWSID =" + n.ID);
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
                this.Disconnect();
            }
        }
    }
}