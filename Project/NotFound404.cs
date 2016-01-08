// <Summary>Helper class for generating html-styled error messages in the browser</Summary>
// <Author>Jeroen Roovers</Author>

namespace Project
{
    public static class NotFound404
    {

        public static string GetInnerHtmlFor404(string message)
        {
            string htmlinner = @"<br/><div class=""row""><div class=""col-8 column""><h1 class=""notfound"">404 Not Found</h1><p>" + message + "</p></div><br><iframe width=\"640\" height=\"480\" src=\"http://thebest404pageever.com/\" frameborder=\"0\" scrolling=\"no\"></iframe></div>";
            return htmlinner;
        }
    }
}