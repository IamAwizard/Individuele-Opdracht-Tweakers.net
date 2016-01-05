<%@ Page Title="" Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="Project.Register" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Tweakers - Registreren</title>
<style type="text/css">
    .auto-style1 {
        width: 220px;
    }
</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder" runat="server">
    <div class="row">
        <div class="col-8 column">
            <div id="registerform" class="loginarea">
                <h1>Registreren</h1>
                <table style="width: 100%;">
                    <tr>
                        <td class="auto-style1">
                            <asp:Label ID="lbl_Username" AssociatedControlID="tbox_Username" runat="server" Text="Gebruikersnaam*"></asp:Label></td>
                        <td>
                            <asp:TextBox ID="tbox_Username" runat="server"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td class="auto-style1">
                            <asp:Label ID="lbl_Email" AssociatedControlID="tbox_Email" runat="server" Text="Emailadres*"></asp:Label></td>
                        <td>
                            <asp:TextBox ID="tbox_email" runat="server" TextMode="Email"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td class="auto-style1">
                            <asp:Label ID="lbl_Password" AssociatedControlID="tbox_Password" runat="server" Text="Wachtwoord*"></asp:Label></td>
                        <td>
                            <asp:TextBox ID="tbox_Password" runat="server" TextMode="Password"></asp:TextBox></td>
                    </tr>
                </table>
                <div id="submit">
                    <asp:Button ID="btn_Login" runat="server" Text="Registreren" />
                </div>

            </div>
        </div>

        <div class="col-4 column">
        </div>
    </div>
</asp:Content>
