<%@ Page Title="" Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" CodeBehind="register.aspx.cs" Inherits="Project.Register" %>

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
                <p>Met een account kun je reacties en productreviews schrijven. Draag ook bij aan de Tweakers community en maak snel een account aan, honderduizenden gingen je voor! </p>
                <table style="width: 100%;">
                    <tr>
                        <td class="auto-style1">
                            <asp:Label ID="lbl_Username" AssociatedControlID="tbox_Username" runat="server" Text="Gebruikersnaam*"></asp:Label></td>
                        <td>
                            <asp:TextBox ID="tbox_Username" runat="server" required="required"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td class="auto-style1">
                            <asp:Label ID="lbl_Email" AssociatedControlID="tbox_Email" runat="server" Text="Emailadres*"></asp:Label></td>
                        <td>
                            <asp:TextBox ID="tbox_email" runat="server" TextMode="Email" required="required"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td class="auto-style1">
                            <asp:Label ID="lbl_Password" AssociatedControlID="tbox_Password" runat="server" Text="Wachtwoord*"></asp:Label></td>
                        <td>
                            <asp:TextBox ID="tbox_Password" runat="server" TextMode="Password" required="required"></asp:TextBox></td>
                    </tr>
                </table>
                <div id="submit">
                    <p>
                        <asp:Label CssClass="errormessage hidden" ID="lbl_ErrorMessage" runat="server" Text="Testtext"></asp:Label>
                    </p>
                    <asp:Button ID="btn_Register" runat="server" Text="Registreren" OnClick="Btn_Register_Click" />
                </div>
            </div>
        </div>
        <div class="col-4 column">
        </div>
    </div>
</asp:Content>
