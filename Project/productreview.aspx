<%@ Page Title="" Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" CodeBehind="productreview.aspx.cs" Inherits="Project.Productreview" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Tweakers - Gebruikersreview</title>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder" runat="server">
    <div class="row">
        <div id="ProductSection" class="productdetails col-12 column " runat="server">
            <div class="ProductSummary">
                <div class=" col-3 column">
                    <h2 class=" text-center">
                        <asp:Label ID="lbl_ProductName" runat="server" Text="IN WIN 05 ZWART"></asp:Label>

                    </h2>
                    <br />
                    <asp:Image ID="img_Product" runat="server" ImageUrl="http://placehold.it/200x150" />
                </div>

                <div class=" col-9 column">
                    <p class="productstuff">
                        <i>Prijs:</i>
                        <asp:Label ID="lbl_ProductMinPrice" runat="server" Text="Label"></asp:Label><br />
                        <i>Specificaties:</i>
                        <asp:Label ID="lbl_ProductSpecs" runat="server" Text="Label"></asp:Label>
                    </p>
                </div>
            </div>
        </div>
        <div id="AddReviewSection" class="productreviews col-12 column" runat="server">
            <p id="schrijfreview">
                Hallo,
                <asp:Label ID="lbl_UserName" runat="server" Text="gebruiker"></asp:Label>.
            </p>
            <p>Je bent een review aan het schrijven voor bovenstaand product. Dank je voor je bijdrage aan tweakers!</p>
            <p>
                <b>Samenvatting* :</b>
            </p>
            <asp:TextBox ID="tbox_Summary" runat="server" TextMode="MultiLine" MaxLength="1024" Rows="3" Height="100%" Width="100%"></asp:TextBox>
            <br />
            <b>Algemene Beoordeling* :</b>
            <br />
            <asp:RadioButtonList ID="rbl_Rating" runat="server" RepeatDirection="Horizontal">
                <asp:ListItem Value="1"></asp:ListItem>
                <asp:ListItem Value="2"></asp:ListItem>
                <asp:ListItem Value="3"></asp:ListItem>
                <asp:ListItem Value="4"></asp:ListItem>
                <asp:ListItem Value="5"></asp:ListItem>
            </asp:RadioButtonList>
            <p><b>Uitgebreide review (optioneel):</b></p>
            <asp:TextBox ID="tbox_Reviewcontent" runat="server" TextMode="MultiLine" MaxLength="1024" Rows="12" Height="100%" Width="100%"></asp:TextBox>
            <br />
            <p>
                <asp:Label ID="lbl_errormessage" CssClass="errormessage" runat="server" Text="*Je samenvatting en/of beoordeling is niet ingevuld terwijl deze verplicht zijn!" Visible="False"></asp:Label>
            </p>
            <br />
            <asp:Button ID="btn_SubmitReview" CssClass="acceptbutton" runat="server" Text="Plaats Review" OnClick="btn_SubmitReview_Click" />
        </div>
        <div id="ReviewsSection" class="productreviews col-12 column" runat="server">
            <div id="reviewtitle" class="userreviewtitle" runat="server">
                <div>
                    <div class="userreviewarea col-8" runat="server">
                        <asp:Repeater ID="RepeaterReview" runat="server">
                            <ItemTemplate>
                                <div class="userreview">
                                    <a href="productreview.aspx?review=<%# DataBinder.Eval(Container.DataItem, "ID") %>">
                                        <h3>Review van <%# DataBinder.Eval(Container.DataItem, "AuthorName") %></h3>
                                    </a>
                                    <p class="smalldate"><%# DataBinder.Eval(Container.DataItem, "LongDateString") %></p>
                                    <p>
                                        <b>Beoordeling: </b><%# DataBinder.Eval(Container.DataItem, "Rating") %>
                                    </p>
                                    <p>
                                        <b>Samenvatting:</b><br />
                                        <%# DataBinder.Eval(Container.DataItem, "Summary") %>
                                    </p>
                                    <p>
                                        <table>
                                            <tr>
                                                <td class="comments">
                                                    <a class="commentcounter" href="productreview.aspx?review=<%# DataBinder.Eval(Container.DataItem, "ID") %>#reacties"><%# DataBinder.Eval(Container.DataItem, "CommentCount") %></a>
                                                </td>
                                            </tr>
                                        </table>
                                    </p>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                        <asp:Repeater ID="RepeaterSingleReview" runat="server">
                            <ItemTemplate>
                                <div class="userreview">
                                    <a >
                                        <h2>Review van <%# DataBinder.Eval(Container.DataItem, "AuthorName") %></h2>
                                    </a>
                                    <p class="smalldate"><%# DataBinder.Eval(Container.DataItem, "LongDateString") %></p>
                                    <p>
                                        <b>Beoordeling: </b><%# DataBinder.Eval(Container.DataItem, "Rating") %>
                                    </p>
                                    <p>
                                        <b>Samenvatting:</b><br />
                                        <%# DataBinder.Eval(Container.DataItem, "Summary") %>
                                    </p>
                                                                        <p>
                                        <b>Review:</b><br />
                                        <%# DataBinder.Eval(Container.DataItem, "Content") %>
                                    </p>

                                    <p>
                                        <table>
                                            <tr>
                                                <td class="comments">
                                                    <a class="commentcounter" href="#reacties"><%# DataBinder.Eval(Container.DataItem, "CommentCount") %></a>
                                                </td>
                                            </tr>
                                        </table>
                                    </p>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </div>
            </div>
        </div>
        <div id="CommentSection" class="comments col-8 column" runat="server">
        </div>
        <div id="AddCommentSection" class="newcomment col-8 column" runat="server">
            <p id="reageer"><b>Reageer:</b></p>
            <asp:TextBox ID="tbox_Comment" runat="server" TextMode="MultiLine" MaxLength="2048" Rows="12" Height="100%" Width="100%"></asp:TextBox>
            <br />
            <asp:Button ID="btn_SendComment" CssClass="acceptbutton" runat="server" Text="Plaats Reactie" OnClick="btn_SendComment_Click" />

        </div>

    </div>
</asp:Content>
