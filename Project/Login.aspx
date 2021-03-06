﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" CodeBehind="login.aspx.cs" Inherits="Project.Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Tweakers - Inloggen</title>
    <style type="text/css">
        .auto-style1 {
            width: 220px;
        }

        .auto-style2 {
            width: 220px;
            height: 32px;
        }

        .auto-style3 {
            height: 32px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder" runat="server">
    <div class="row">
        <div class="col-8 column">
            <div id="loginform" class="loginarea">
                <h1>Inloggen</h1>
                <p> Nog geen account?<br /><a href="register.aspx">Registreer nu</a> om reacties en gebruikersreviews te kunnen plaatsen!</p>
                <table style="width: 100%;">
                    <tr>
                        <td class="auto-style1">
                            <asp:Label ID="lbl_Username" AssociatedControlID="tbox_Username" runat="server" Text="Gebruikersnaam (Emailadres)*"></asp:Label></td>
                        <td>
                            <asp:TextBox ID="tbox_Username" runat="server" required="required"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td class="auto-style2">
                            <asp:Label ID="lbl_Password" AssociatedControlID="tbox_Password" runat="server" Text="Wachtwoord*"></asp:Label></td>
                        <td class="auto-style3">
                            <asp:TextBox ID="tbox_Password" runat="server" TextMode="Password" required="required"></asp:TextBox></td>
                    </tr>
                </table>
                <div id="submit">
                    <p>
                        <asp:Label CssClass="errormessage" ID="lbl_ErrorMessage" runat="server" Text="Testtext" Visible="False"></asp:Label>
                    </p>
                    <asp:HyperLink ID="hlink_RecoverPassword" runat="server" NavigateUrl="#">Wachtwoord vergeten (to-do)</asp:HyperLink><br />
                    <asp:Button ID="btn_Login" runat="server" Text="Inloggen" OnClick="Btn_Login_Click" />
                </div>
            </div>
        </div>

        <div class="col-4 column">
        </div>
    </div>
</asp:Content>
