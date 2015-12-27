<%@ Page Title="" Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Project.Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Tweakers - Wij stellen technologie op de proef</title>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder" runat="server">
    <br />
    <div class="row">
        <div class="col-4 column">
            <div class="highlight">
                <asp:HyperLink ID="link_Highlight1" runat="server" NavigateUrl="#">
                    <h2>Panasonic Televisie Galore</h2>
                    <p>UHD Krijgt een 5/7</p> 
                </asp:HyperLink><br />
                <asp:ImageButton ID="img_Highlight1" runat="server" Width="100%" ImageUrl="http://ic.tweakimg.net/ext/i/thumbs_fpa_small/2000881558.jpeg" /><br />
                <div class="overlay">
                    <asp:HyperLink ID="link_Highlight1Comments" runat="server">39 reacties</asp:HyperLink>
                </div>
            </div>
        </div>
        <div class="col-4 column">
            <div class="highlight">
                <asp:HyperLink ID="link_Highlight2" runat="server" NavigateUrl="#">
                    <h2>Special: Cyber (in)Security</h2>
                    <p>Hoe breken hackers in?</p> 
                </asp:HyperLink><br />
                <asp:ImageButton ID="img_Highlight2" runat="server" Width="100%" ImageUrl="http://ic.tweakimg.net/ext/i/thumbs_fpa_small/2000894783.jpeg" /><br />
                <div class="overlay">
                    <asp:HyperLink ID="link_Highlight2Comments" runat="server">61 Reacties</asp:HyperLink>
                </div>
            </div>
        </div>
        <div class="col-4 column">
            <div class="highlight last">
                <asp:HyperLink ID="link_Highlight3" runat="server" NavigateUrl="#">
                    <h2>Telefoons op de pijnbank</h2>
                    <p>Welke zijn het beste?</p>
                </asp:HyperLink><br />
                <asp:ImageButton ID="img_Highlight3" runat="server" Width="100%" ImageUrl="http://ic.tweakimg.net/ext/i/thumbs_fpa_small/2000881530.jpeg" /><br />
                <div class="overlay">
                    <asp:HyperLink ID="link_Highlight3Comments" runat="server">285 Reacties</asp:HyperLink>
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-8 column">
            <p class="callout">
                swaggy 1
            </p>
        </div>
        <div class="col-4 column">
            <p class="callout">
                swaggy 2
            </p>
        </div>
    </div>
</asp:Content>
