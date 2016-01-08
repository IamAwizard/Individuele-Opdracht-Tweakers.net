<%@ Page Title="" Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" CodeBehind="pricewatch.aspx.cs" Inherits="Project.Pricewatch" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Tweakers - Pricewatch</title>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder" runat="server">
    <div class="row">
        <h2>
            Pricewatch
        </h2>
        <div id="SearchbarSection" class=" searchbar col-12 column " runat="server">
            <asp:TextBox ID="tbox_Search" CssClass="text" placeholder="Zoek een product" runat="server"></asp:TextBox><asp:Button ID="btn_Search" runat="server" Text="Zoeken" CssClass="acceptbutton" OnClick="Btn_Search_Click" />
        </div>
        <div id="SearchResultsSection" class="col-12 column " runat="server">
            <asp:Table ID="table_SearchResults" CssClass="productlist" runat="server" Visible="True"></asp:Table>
        </div>

        <div id="ProductSection" class="productdetails col-12 column " runat="server">
            <div class="ProductSummary">
                <div class=" col-3 column">
                    <h2 class=" text-center">
                        <asp:Label ID="lbl_ProductName" runat="server" Text="IN WIN 05 ZWART"></asp:Label>

                    </h2>
                    <br />
                    <asp:Image ID="img_Product" runat="server" ImageUrl="http://placehold.it/200x150" />
                    <br />
                    <asp:Button ID="btn_UserReviews" class="acceptbutton" runat="server" Text="Gebruikersreviews" Width="70%" OnClick="Btn_UserReviews_Click" />
                    <br />
                    <br />
                    <asp:Button ID="btn_WriteNewReview" class="acceptbutton" runat="server" Text="Review Schrijven" Width="70%" OnClick="Btn_WriteNewReview_Click" />
                </div>

                <div class=" col-9 column">
                    <p class="productstuff">
                        <i>Prijs:</i>
                        <asp:Label ID="lbl_ProductMinPrice" runat="server" Text="Label"></asp:Label><br />
                        <i>Specificaties:</i>
                        <asp:Label ID="lbl_ProductSpecs" runat="server" Text="Label"></asp:Label>
                    </p>
                    <hr />
                    <asp:Table ID="table_ProductPrices" CssClass="productprices" runat="server"></asp:Table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
