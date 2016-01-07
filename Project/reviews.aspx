<%@ Page Title="" Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" CodeBehind="reviews.aspx.cs" Inherits="Project.Reviews" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Tweakers - Reviews</title>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder" runat="server">
    <div class="row">
        <div id="ReviewsArea" class="col-12 column reviewarea" runat="server">
        </div>
        <div class="row">

                <div id="comments" class="comments col-8 column" runat="server">
                </div>


                <div id="addcomment" class="newcomment col-8 column" runat="server">
                    <p id="reageer"><b>Reageer:</b></p>
                    <asp:textbox id="tbox_Comment" runat="server" textmode="MultiLine" maxlength="2048" rows="12" height="100%" width="100%" min-height="100px"></asp:textbox>
                    <br />
                    <asp:button id="btn_SendComment" cssclass="acceptbutton" runat="server" text="Plaats Reactie" onclick="Btn_SendComment_Click" />
                </div>

        </div>
    </div>
</asp:Content>
