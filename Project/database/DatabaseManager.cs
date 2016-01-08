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
        private void Disconnect()
        {
            this.con.Close();
            this.con.Dispose();
        }

        private string SafeReadString(OracleDataReader odr, int colIndex)
        {
            {
                if (!odr.IsDBNull(colIndex))
                    return odr.GetString(colIndex);
                else
                    return string.Empty;
            }
        }

        private int SafeReadInt(OracleDataReader odr, int colIndex)
        {
            {
                if (!odr.IsDBNull(colIndex))
                    return odr.GetInt32(colIndex);
                else
                    return -1;
            }
        }

        private decimal SafeReadDecimal(OracleDataReader odr, int colIndex)
        {
            {
                if (!odr.IsDBNull(colIndex))
                    return odr.GetDecimal(colIndex);
                else
                    return 0;
            }
        }

        private DateTime SafeReadDateTime(OracleDataReader odr, int colIndex)
        {
            {
                if (!odr.IsDBNull(colIndex))
                    return odr.GetDateTime(colIndex);
                else
                    return DateTime.MinValue;
            }
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

        /// <summary>
        /// Does the same as SimpleRead
        /// But does not automatically start the reader, so you can still add parameters
        /// </summary>
        /// <param name="sql"></param>
        private void SimpleReadWithParaMeters(string sql)
        {
            try
            {
                this.cmd = new OracleCommand();
                this.cmd.Connection = this.con;
                this.cmd.CommandText = sql;
                this.cmd.CommandType = CommandType.Text;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine(ex.Message);
            }
        }

        public News GetNewsByID(int id)
        {
            try
            {
                this.Connect();
                News foo = null;

                this.SimpleReadWithParaMeters("SELECT * FROM NIEUWS WHERE NIEUWSID = :someNIEUWSID");
                this.cmd.Parameters.Add("someNIEUWSID", id);
                this.dr = this.cmd.ExecuteReader();
                while (this.dr.Read())
                {
                    var newsid = this.SafeReadInt(this.dr, 0);
                    var title = this.SafeReadString(this.dr, 1);
                    var date = this.SafeReadDateTime(this.dr, 2);
                    var content = this.SafeReadString(this.dr, 3);

                    foo = new News(id, title, date, content);
                }

                return foo;
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

        public Review GetReviewByID(int id)
        {
            try
            {
                this.Connect();
                Review foo = null;

                this.SimpleReadWithParaMeters("SELECT * FROM REVIEW WHERE REVIEWID = :someREVIEWID");
                this.cmd.Parameters.Add("someREVIEWID", id);
                this.dr = this.cmd.ExecuteReader();
                while (this.dr.Read())
                {
                    var reviewid = this.SafeReadInt(this.dr, 0);
                    var title = this.SafeReadString(this.dr, 1);
                    var subtitle = this.SafeReadString(this.dr, 2);
                    var summary = this.SafeReadString(this.dr, 3);
                    var date = this.SafeReadDateTime(this.dr, 4);
                    var thumbnail = this.SafeReadString(this.dr, 5);
                    var highlightphoto = this.SafeReadString(this.dr, 5);

                    foo = new Review(id, title, summary, date);
                    foo.SubTitle = subtitle;
                    foo.ThumbNail = thumbnail;
                    foo.HighLight = highlightphoto;
                }

                this.SimpleRead("SELECT * FROM REVIEWPAGINA WHERE REVIEWID = " + id + " ORDER BY PAGINANR");
                while (this.dr.Read())
                {
                    var pageid = this.SafeReadInt(this.dr, 0);
                    var pagenr = this.SafeReadInt(this.dr, 1);
                    var pagesubtitle = this.SafeReadString(this.dr, 2);
                    var pagecontent = this.SafeReadString(this.dr, 3);

                    ReviewPage toadd = new ReviewPage(pageid, pagenr, pagesubtitle, pagecontent);
                    foo.Pages.Add(toadd);
                }

                return foo;
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

        public List<Comment> GetCommentsOnNewsByNewsID(int newsid)
        {
            try
            {
                this.Connect();
                List<Comment> foo = new List<Comment>();

                this.SimpleReadWithParaMeters("SELECT R.REACTIEID, U.USERACCOUNTID, U.ACCOUNTNAAM, U.EMAIL, R.DATUM, CONTENT FROM REACTIE R, USERACCOUNT U WHERE EXTERNID = :someNIEUWSID AND REACTIETYPEID = 1 AND R.AUTEUR = U.USERACCOUNTID");
                this.cmd.Parameters.Add("someNIEUWSID", newsid);
                this.dr = this.cmd.ExecuteReader();
                while (this.dr.Read())
                {
                    var commentid = this.SafeReadInt(this.dr, 0);
                    var authorid = this.SafeReadInt(this.dr, 1);
                    var authorname = this.SafeReadString(this.dr, 2);
                    var authoremail = this.SafeReadString(this.dr, 3);
                    var commentdate = this.SafeReadDateTime(this.dr, 4);
                    var commentcontent = this.SafeReadString(this.dr, 5);

                    UserAccount author = new UserAccount(authorid, authorname, authoremail);
                    Comment toadd = new Comment(commentid, commentdate, author, CommentType.CommentOnNews, commentcontent);
                    foo.Add(toadd);
                }
                return foo;
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

        public List<Comment> GetCommentsOnReviewByReviewID(int reviewid)
        {
            try
            {
                this.Connect();
                List<Comment> foo = new List<Comment>();

                this.SimpleReadWithParaMeters("SELECT R.REACTIEID, U.USERACCOUNTID, U.ACCOUNTNAAM, U.EMAIL, R.DATUM, CONTENT FROM REACTIE R, USERACCOUNT U WHERE EXTERNID = :someREVIEWID AND REACTIETYPEID = 2 AND R.AUTEUR = U.USERACCOUNTID");
                this.cmd.Parameters.Add("someREVIEWID", reviewid);
                this.dr = this.cmd.ExecuteReader();
                while (this.dr.Read())
                {
                    var commentid = this.SafeReadInt(this.dr, 0);
                    var authorid = this.SafeReadInt(this.dr, 1);
                    var authorname = this.SafeReadString(this.dr, 2);
                    var authoremail = this.SafeReadString(this.dr, 3);
                    var commentdate = this.SafeReadDateTime(this.dr, 4);
                    var commentcontent = this.SafeReadString(this.dr, 5);

                    UserAccount author = new UserAccount(authorid, authorname, authoremail);
                    Comment toadd = new Comment(commentid, commentdate, author, CommentType.CommentOnNews, commentcontent);
                    foo.Add(toadd);
                }
                return foo;
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

        public List<Comment> GetCommentsOnNewsByUserReviewID(int userreviewid)
        {
            try
            {
                this.Connect();
                List<Comment> foo = new List<Comment>();

                this.SimpleReadWithParaMeters("SELECT R.REACTIEID, U.USERACCOUNTID, U.ACCOUNTNAAM, U.EMAIL, R.DATUM, CONTENT FROM REACTIE R, USERACCOUNT U WHERE EXTERNID = :someID AND REACTIETYPEID = 3 AND R.AUTEUR = U.USERACCOUNTID");
                this.cmd.Parameters.Add("someID", userreviewid);
                this.dr = this.cmd.ExecuteReader();
                while (this.dr.Read())
                {
                    var commentid = this.SafeReadInt(this.dr, 0);
                    var authorid = this.SafeReadInt(this.dr, 1);
                    var authorname = this.SafeReadString(this.dr, 2);
                    var authoremail = this.SafeReadString(this.dr, 3);
                    var commentdate = this.SafeReadDateTime(this.dr, 4);
                    var commentcontent = this.SafeReadString(this.dr, 5);

                    UserAccount author = new UserAccount(authorid, authorname, authoremail);
                    Comment toadd = new Comment(commentid, commentdate, author, CommentType.CommentOnNews, commentcontent);
                    foo.Add(toadd);
                }
                return foo;
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

        public List<Product> GetProductsByName(string searchstring)
        {
            try
            {
                this.Connect();
                List<Product> returnlist = new List<Product>();

                searchstring = searchstring.Insert(0, "%");
                searchstring += "%";
                this.SimpleReadWithParaMeters("SELECT * FROM PRODUCT WHERE UPPER(NAAM) LIKE UPPER(:productNAAM) ");
                this.cmd.Parameters.Add("productNAAM", searchstring);
                this.dr = this.cmd.ExecuteReader();

                while (this.dr.Read())
                {
                    var id = this.SafeReadInt(this.dr, 0);
                    var name = this.SafeReadString(this.dr, 1);
                    var photo = this.SafeReadString(this.dr, 2);
                    var content = this.SafeReadString(this.dr, 3);

                    Product toadd = new Product(id, name, content, photo);
                    returnlist.Add(toadd);
                }


                foreach (Product p in returnlist)
                {
                    this.SimpleRead("select * from prijs p FULL OUTER JOIN winkel w ON p.winkelid = w.winkelid where productid = " + p.ID);
                    while (this.dr.Read())
                    {
                        var priceid = this.SafeReadInt(this.dr, 0);
                        var productid = this.SafeReadInt(this.dr, 1);
                        var shopid = this.SafeReadInt(this.dr, 2);
                        var price = this.SafeReadDecimal(this.dr, 3);
                        var shop = this.SafeReadInt(this.dr, 4);
                        var shopname = this.SafeReadString(this.dr, 5);
                        var shopsite = this.SafeReadString(this.dr, 6);
                        var shopcontent = this.SafeReadString(this.dr, 7);
                        var shopphoto = this.SafeReadString(this.dr, 8);

                        Price toadd = new Price(priceid, shopid, productid, price);
                        toadd.AssociatedShop = new Shop(shop, shopname, shopsite, shopcontent, shopphoto);
                        p.Pricing.Add(toadd);
                    }

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

        public Product GetProductByID(int productid)
        {
            try
            {
                this.Connect();
                Product returnvalue = null;

                this.SimpleReadWithParaMeters("SELECT * FROM PRODUCT WHERE PRODUCTID = :productID ");
                this.cmd.Parameters.Add("productID", productid);
                this.dr = this.cmd.ExecuteReader();

                while (this.dr.Read())
                {
                    var id = this.SafeReadInt(this.dr, 0);
                    var name = this.SafeReadString(this.dr, 1);
                    var photo = this.SafeReadString(this.dr, 2);
                    var content = this.SafeReadString(this.dr, 3);

                    returnvalue = new Product(id, name, content, photo);
                }

                this.SimpleReadWithParaMeters("select * from prijs p FULL OUTER JOIN winkel w ON p.winkelid = w.winkelid where productid = :productID ");
                this.cmd.Parameters.Add("productID", productid);
                this.dr = this.cmd.ExecuteReader();

                while (this.dr.Read())
                {
                    var priceid = this.SafeReadInt(this.dr, 0);
                    var prodid = this.SafeReadInt(this.dr, 1);
                    var shopid = this.SafeReadInt(this.dr, 2);
                    var price = this.SafeReadDecimal(this.dr, 3);
                    var shop = this.SafeReadInt(this.dr, 4);
                    var shopname = this.SafeReadString(this.dr, 5);
                    var shopsite = this.SafeReadString(this.dr, 6);
                    var shopcontent = this.SafeReadString(this.dr, 7);
                    var shopphoto = this.SafeReadString(this.dr, 8);

                    Price toadd = new Price(priceid, shopid, prodid, price);
                    toadd.AssociatedShop = new Shop(shop, shopname, shopsite, shopcontent, shopphoto);
                    returnvalue.Pricing.Add(toadd);
                }
                return returnvalue;
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

        public List<News> GetLatestNews()
        {
            try
            {
                this.Connect();
                List<News> returnlist = new List<News>();

                this.SimpleRead("SELECT * FROM " +
                    "(SELECT N.NIEUWSID, N.DATUM, N.TITEL, COUNT(R.REACTIEID) AS AANTALREACTIES " +
                    "FROM NIEUWS N LEFT JOIN  REACTIE R ON N.NIEUWSID = R.EXTERNID AND R.REACTIETYPEID = 1" +
                    "GROUP BY N.NIEUWSID, N.DATUM, N.TITEL " +
                    "ORDER BY DATUM DESC) " +
                    "WHERE ROWNUM <= 30");

                while (this.dr.Read())
                {
                    var id = this.dr.GetInt32(0);
                    var date = this.dr.GetDateTime(1);
                    var title = this.dr.GetString(2);
                    var comments = this.dr.GetDecimal(3);

                    News toadd = new News(id, title, date);
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
                                       "(SELECT N.NIEUWSID, N.DATUM, N.TITEL, COUNT(R.REACTIEID) AS AANTALREACTIES " +
                                       "FROM NIEUWS N LEFT JOIN  REACTIE R ON N.NIEUWSID = R.EXTERNID AND R.REACTIETYPEID = 1 " +
                                       "GROUP BY N.NIEUWSID, N.DATUM, N.TITEL " +
                                       "ORDER BY DATUM DESC) " +
                                       "WHERE ROWNUM <= 30");

                while (this.dr.Read())
                {
                    var id = this.dr.GetInt32(0);
                    var date = this.dr.GetDateTime(1);
                    var title = this.dr.GetString(2);
                    var comments = this.dr.GetDecimal(3);

                    News toadd = new News(id, title, date);
                    toadd.CommentCount = (int)comments;

                    returnlist.Add(toadd);
                }

                foreach (News n in returnlist)
                {
                    this.SimpleRead("SELECT CONTENT FROM NIEUWS WHERE NIEUWSID =" + n.ID);
                    while (this.dr.Read())
                    {
                        var content = this.SafeReadString(this.dr, 0);

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

        public List<Review> GetLatestReviews()
        {
            try
            {
                this.Connect();
                List<Review> returnlist = new List<Review>();

                this.SimpleRead("SELECT * FROM (" +
                                       "SELECT RV.REVIEWID, RV.TITEL, RV.SAMENVATTING, RV.DATUM, COUNT(R. REACTIEID), RV.THUMBFOTO, RV.HIGHLIGHTFOTO, RV.SUBTITEL " +
                                        "FROM REVIEW RV LEFT JOIN REACTIE R ON R.EXTERNID = RV.REVIEWID AND REACTIETYPEID = 2 " +
                                        "GROUP BY RV.REVIEWID, RV.TITEL, RV.SAMENVATTING, RV.DATUM, RV.THUMBFOTO, RV.HIGHLIGHTFOTO, RV.SUBTITEL " +
                                        "ORDER BY RV.DATUM DESC) " +
                                        "WHERE ROWNUM < 11");
                while (this.dr.Read())
                {
                    var id = this.SafeReadInt(this.dr, 0);
                    var title = this.SafeReadString(this.dr, 1);
                    var summary = this.SafeReadString(this.dr, 2);
                    var date = this.SafeReadDateTime(this.dr, 3);
                    var commentcount = this.SafeReadDecimal(this.dr, 4);
                    var thumb = this.SafeReadString(this.dr, 5);
                    var fpphoto = this.SafeReadString(this.dr, 6);
                    var subtitle = this.SafeReadString(this.dr, 7);

                    Review toadd = new Review(id, title, summary, date);
                    toadd.CommentCount = (int)commentcount;
                    toadd.ThumbNail = thumb;
                    toadd.HighLight = fpphoto;
                    toadd.SubTitle = subtitle;
                    returnlist.Add(toadd);
                }
                foreach (Review r in returnlist)
                {
                    this.SimpleRead("SELECT * FROM REVIEWPAGINA WHERE REVIEWID = " + r.ID + " ORDER BY PAGINANR");
                    while (this.dr.Read())
                    {
                        var pageid = this.SafeReadInt(this.dr, 0);
                        var pagenr = this.SafeReadInt(this.dr, 1);
                        var pagesubtitle = this.SafeReadString(this.dr, 2);
                        var pagecontent = this.SafeReadString(this.dr, 3);

                        ReviewPage toadd = new ReviewPage(pageid, pagenr, pagesubtitle, pagecontent);
                        r.Pages.Add(toadd);
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

        public List<UserAccount> GetUserCache()
        {
            try
            {
                this.Connect();
                List<UserAccount> returnlist = new List<UserAccount>();

                this.SimpleRead("SELECT USERACCOUNTID, ACCOUNTNAAM, LOWER(EMAIL), NAAM, FOTO, GEBOORTEDATUM FROM USERACCOUNT");
                while (this.dr.Read())
                {
                    var id = this.SafeReadInt(this.dr, 0);
                    var username = this.SafeReadString(this.dr, 1);
                    var email = this.SafeReadString(this.dr, 2);
                    var givenname = this.SafeReadString(this.dr, 3);
                    var photo = this.SafeReadString(this.dr, 4);
                    var dob = this.SafeReadDateTime(this.dr, 5);

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
                if (this.dr.HasRows)
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

        public bool CheckUsernameUnique(string username)
        {
            try
            {
                this.Connect();

                this.cmd = new OracleCommand();
                this.cmd.Connection = this.con;
                this.cmd.CommandText = "SELECT * FROM USERACCOUNT WHERE LOWER(ACCOUNTNAAM) = LOWER(:newACCOUNTNAAM)";
                this.cmd.Parameters.Add("newACCOUNTNAAM", username);
                this.cmd.CommandType = CommandType.Text;
                this.dr = this.cmd.ExecuteReader();
                if (this.dr.HasRows)
                {
                    return false;
                }
                else
                {
                    return true;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine(ex.Message);
                return false;
            }
            finally
            {
                this.Disconnect();
            }
        }

        public bool CheckEmailUnique(string email)
        {
            try
            {
                this.Connect();

                this.cmd = new OracleCommand();
                this.cmd.Connection = this.con;
                this.cmd.CommandText = "SELECT * FROM USERACCOUNT WHERE LOWER(EMAIL) = LOWER(:newEMAIL)";
                this.cmd.Parameters.Add("newEMAIL", email);
                this.cmd.CommandType = CommandType.Text;
                this.dr = this.cmd.ExecuteReader();
                if (this.dr.HasRows)
                {
                    return false;
                }
                else
                {
                    return true;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine(ex.Message);
                return false;
            }
            finally
            {
                this.Disconnect();
            }
        }

        public void AddUser(UserAccount newuser)
        {
            try
            {
                this.Connect();

                this.cmd = new OracleCommand();
                this.cmd.Connection = this.con;
                this.cmd.CommandText = "INSERT INTO USERACCOUNT(ACCOUNTNAAM, WACHTWOORD, EMAIL) VALUES (:newACCOUNTNAAM, :newWACHTWOORD, :newEMAIL)";
                this.cmd.Parameters.Add("newACCOUNTNAAM", newuser.AccountName);
                this.cmd.Parameters.Add("newWACHTWOORD", newuser.Password);
                this.cmd.Parameters.Add("newEMAIL", newuser.Email);
                this.cmd.CommandType = CommandType.Text;

                this.cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine(ex.Message);
            }
            finally
            {
                this.Disconnect();
            }
        }

        public void AddComment(Comment newcomment, int itemIDtoBeCommentedOn)
        {
            try
            {
                this.Connect();

                this.cmd = new OracleCommand();
                this.cmd.Connection = this.con;
                this.cmd.CommandText = "INSERT INTO REACTIE(AUTEUR, EXTERNID, REACTIETYPEID, DATUM, CONTENT) VALUES (:newAUTEUR, :newEXTERNID, :newREACTIETYPEID, :newDATUM, :newCONTENT)";
                this.cmd.Parameters.Add("newAUTEUR", newcomment.Author.ID);
                this.cmd.Parameters.Add("newEXTERNID", itemIDtoBeCommentedOn);
                this.cmd.Parameters.Add("newREACTIETYPEID", (int)newcomment.Type);
                this.cmd.Parameters.Add("newDATUM", newcomment.Date);
                this.cmd.Parameters.Add("newCONTENT", newcomment.Content);
                this.cmd.CommandType = CommandType.Text;

                this.cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine(ex.Message);
            }
            finally
            {
                this.Disconnect();
            }
        }

        public void AddUserReview(UserReview newreview)
        {
            try
            {
                this.Connect();

                this.cmd = new OracleCommand();
                this.cmd.Connection = this.con;
                this.cmd.CommandText = "INSERT INTO GEBRUIKERSREVIEW (ProductID, Auteur, Datum, Samenvatting, Content, Beoordeling) VALUES (:newProdID, :newAuteur, :newDate, :newSummary, :newContent, :newRating)";
                this.cmd.Parameters.Add("newProdID", newreview.ProductID);
                this.cmd.Parameters.Add("newAuteur", newreview.AuthorID);
                this.cmd.Parameters.Add("newDate", newreview.Date);
                this.cmd.Parameters.Add("newSummary", newreview.Summary);
                this.cmd.Parameters.Add("newContent", newreview.Content);
                this.cmd.Parameters.Add("newRating", newreview.Rating);
                this.cmd.CommandType = CommandType.Text;

                this.cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine(ex.Message);
            }
            finally
            {
                this.Disconnect();
            }
        }

        public bool CheckUserReviewUnique(UserReview re)
        {
            try
            {
                this.Connect();

                this.cmd = new OracleCommand();
                this.cmd.Connection = this.con;
                this.cmd.CommandText = string.Format("SELECT * FROM GEBRUIKERSREVIEW WHERE PRODUCTID = {0} AND AUTEUR = {1}", re.ProductID, re.AuthorID);
                this.cmd.CommandType = CommandType.Text;

                this.dr = this.cmd.ExecuteReader();
                if (this.dr.HasRows)
                {
                    return false;
                }
                return true;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine(ex.Message);
                return false;
            }
            finally
            {
                this.Disconnect();
            }
        }

        public List<UserReview> GetUserReviews(int productid)
        {
            try
            {
                this.Connect();
                List<UserReview> returnlist = new List<UserReview>();
                this.cmd = new OracleCommand();
                this.cmd.Connection = this.con;
                this.cmd.CommandText = string.Format("select gr.gebruikersreviewid, gr.productid, ua.ACCOUNTNAAM, gr.datum, gr.samenvatting, count(r.reactieid), gr.BEOORDELING from gebruikersreview gr LEFT JOIN REACTIE R ON R.EXTERNID = gr.GEBRUIKERSREVIEWID  AND R.REACTIETYPEID = 3, USERACCOUNT ua WHERE gr.PRODUCTID = {0} AND gr.AUTEUR = ua.USERACCOUNTID GROUP BY gr.gebruikersreviewid, gr.productid, ua.ACCOUNTNAAM, gr.datum, gr.samenvatting, gr.BEOORDELING ORDER BY gr.GEBRUIKERSREVIEWID DESC", productid);
                this.cmd.CommandType = CommandType.Text;
                this.dr = this.cmd.ExecuteReader();

                while (dr.Read())
                {
                    var reviewid = this.SafeReadInt(this.dr, 0);
                    var prodid = this.SafeReadInt(this.dr, 1);
                    var username = this.SafeReadString(this.dr, 2);
                    var date = this.SafeReadDateTime(this.dr, 3);
                    var summary = this.SafeReadString(this.dr, 4);
                    var commentcount = (int)this.SafeReadDecimal(this.dr, 5);
                    var rating = this.SafeReadInt(this.dr, 6);
                    UserReview review = new UserReview(reviewid, prodid, username, date, summary, commentcount, rating);
                    returnlist.Add(review);
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

        public UserReview GetUserReviewByID(int id)
        {
            try
            {
                this.Connect();
                UserReview foo = null;

                this.cmd.Connection = this.con;
                this.cmd.CommandText = string.Format("select gr.gebruikersreviewid, gr.productid, ua.ACCOUNTNAAM, gr.datum, gr.samenvatting, count(r.reactieid), gr.BEOORDELING from gebruikersreview gr LEFT JOIN REACTIE R ON R.EXTERNID = gr.GEBRUIKERSREVIEWID  AND R.REACTIETYPEID = 3, USERACCOUNT ua WHERE gr.GEBRUIKERSREVIEWID = {0} AND gr.AUTEUR = ua.USERACCOUNTID GROUP BY gr.gebruikersreviewid, gr.productid, ua.ACCOUNTNAAM, gr.datum, gr.samenvatting, gr.BEOORDELING ORDER BY gr.GEBRUIKERSREVIEWID DESC", id);
                this.cmd.CommandType = CommandType.Text;
                this.dr = this.cmd.ExecuteReader();
                while (this.dr.Read())
                {
                    var reviewid = this.SafeReadInt(this.dr, 0);
                    var prodid = this.SafeReadInt(this.dr, 1);
                    var username = this.SafeReadString(this.dr, 2);
                    var date = this.SafeReadDateTime(this.dr, 3);
                    var summary = this.SafeReadString(this.dr, 4);
                    var commentcount = (int)this.SafeReadDecimal(this.dr, 5);
                    var rating = this.SafeReadInt(this.dr, 6);
                    foo = new UserReview(reviewid, prodid, username, date, summary, commentcount, rating);
                }

                if (foo != null)

                    this.SimpleRead(string.Format("SELECT CONTENT GEBRUIKERSREVIEW WHERE GEBRUIKERSREVIEWID = {0}", id));
                while (this.dr.Read())
                {
                    var content = this.SafeReadString(this.dr, 0);
                    foo.Content = content;
                }

                return foo;
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
    }
}