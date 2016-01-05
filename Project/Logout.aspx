<%@ Page Title="" Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" CodeBehind="logout.aspx.cs" Inherits="Project.Logout" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Tweakers - Uitloggen...</title>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder" runat="server">
    <div class="row">
        <div class="col-8 column">
            <div id="loginform" class="loginarea">
                <h1 id="LogoutHeader" runat="server">Uitloggen...</h1>
                <p class="callout">
                    Je wordt doorgestuurd naar de begin pagina.
                </p>
            </div>
            <div class="col-4 column">
            </div>
        </div>
    </div>
</asp:Content>
