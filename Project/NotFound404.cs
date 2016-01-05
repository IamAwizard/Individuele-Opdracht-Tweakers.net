using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Project
{
    public static class NotFound404
    {

        public static string GetInnerHtmlFor404(string message)
        {
            string htmlinner = @"<br/><div class=""row""><div class=""col-8 column""><h1 class=""notfound"">404 Not Found</h1><p>" + message + "</p></div><div id=\"swaggy\" class=\"col-4 column\"><iframe width=\"640\" height=\"480\" src=\"http://thebest404pageever.com/\" frameborder=\"0\" scrolling=\"no\"></iframe></div></div>";
            return htmlinner;
        }

        
    }
}