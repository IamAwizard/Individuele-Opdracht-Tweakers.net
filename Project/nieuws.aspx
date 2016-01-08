<%@ Page Title="" Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" CodeBehind="nieuws.aspx.cs" Inherits="Project.Nieuws" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Tweakers - Laatste Nieuws</title>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder" runat="server">
    <div class="row">
        <div id="NewsArea" class="col-12 column" runat="server">
        </div>
        <div class="row">
                <div id="comments" class="comments col-8 column" runat="server">
                </div>
                <div id="addcomment" class="newcomment col-8 column" runat="server">
                    <p id="reageer"><b>Reageer:</b></p>
                    <asp:TextBox ID="tbox_Comment" runat="server" TextMode="MultiLine" MaxLength="2048" Rows="12" Height="100%" Width="100%"></asp:TextBox>
                    <br />
                    <asp:Button ID="btn_SendComment" CssClass="acceptbutton" runat="server" Text="Plaats Reactie" OnClick="Btn_SendComment_Click" />
                </div>
        </div>
    </div>
</asp:Content>
