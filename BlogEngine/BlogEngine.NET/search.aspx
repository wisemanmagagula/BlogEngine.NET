<%@ Page Language="C#" AutoEventWireup="true" EnableViewState="false" Inherits="search" ValidateRequest="false" Codebehind="search.aspx.cs" %>

<%@ Import Namespace="BlogEngine.Core" %>
<asp:content id="Content1" contentplaceholderid="cphBody" runat="Server">
  <div class="searchpage post search-page page-global">
    <h2 runat="server" class="page-global-title" id="h1Headline" />
    <div id="searchpage" class="search-page-searchbox clearfix">
      <input type="text" name="q" id="q" value="<%=Server.HtmlEncode(Request.QueryString["q"]) %>" onkeypress="if(event.keyCode==13) { SearchPage(); return false; }" />
      <input type="button" value="<%=Resources.labels.search %>" class="btn btn-primary" onclick="SearchPage()" onkeypress="SearchPage()" />
        <div >      <button id="speechToTextButton" onclick="startSpeechRecognition(); return false;" class="green-button">Speech To Text</button></div>
      <% if (BlogSettings.Instance.EnableCommentSearch && BlogSettings.Instance.ShowIncludeCommentsOption)
         { %>
      <input type="checkbox" name="comment" id="comment" /><label for="comment"><%=BlogSettings.Instance.SearchCommentLabelText %></label>
      <%} %>
    </div>

    <script type="text/javascript">      
        //<![CDATA[ 
        var check = document.getElementById('comment');
      
        function SearchPage()
        {   
            var searchTerm = encodeURIComponent(document.getElementById('q').value);
            var include = check ? check.checked : false;
            var comment = '&comment=true';
       
            if (!include)
            {
                comment = '';
            }

            var url = '<%=Utils.RelativeWebRoot %>search<%= BlogConfig.FileExtension %>?q=' + searchTerm + comment;
        
            location.href = url;
        }
      
        if (check != null)
        {
            check.checked = <%=(Request.QueryString["comment"] != null).ToString().ToLowerInvariant() %>;
        }

        function startSpeechRecognition() {
            const recognition = new (window.SpeechRecognition || window.webkitSpeechRecognition)();

            recognition.lang = 'en-US';
            recognition.interimResults = false;
            recognition.maxAlternatives = 1;

            recognition.start();

            recognition.onresult = function (event) {
                const transcript = event.results[0][0].transcript;
                document.getElementById('q').value = transcript;
            };

            recognition.onerror = function (event) {
                console.error('Recognition error:', event.error);
            };
        }
        //]]>
    </script>
  
    <style>
      .green-button {
          background-color: green;
          color: white;
          border: none;
          padding: 10px 20px;
          cursor: pointer;
          border-radius: 5px;
          position: absolute;
          top: 0;
          left: 0;
      }
    </style>

    <asp:repeater runat="server" id="rep">
      <ItemTemplate>
        <div class="searchresult">
          <a href="<%# Eval("AbsoluteLink") %>"><%# Eval("Title") %></a>
          <span class="text"><%# GetContent((string)Eval("Description"), (string)Eval("Content")) %></span>
         <span class="type" runat="server" id="type" />
          <span class="url"><%# ShortenUrl(Eval("AbsoluteLink").ToString())%></span>
        </div>
      </ItemTemplate>
    </asp:repeater>
    
    <asp:PlaceHolder ID="Paging" runat="server" />
  </div>
</asp:content>