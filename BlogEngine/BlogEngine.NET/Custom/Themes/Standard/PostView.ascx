﻿<%@ Control Language="C#" AutoEventWireup="true" EnableViewState="false" Inherits="BlogEngine.Core.Web.Controls.PostViewBase" %>
<%@ Import Namespace="BlogEngine.Core" %>
<%
    var singlePost = Location == ServingLocation.SinglePost;
    var postClass = "";
    var postAdminLinks = "";
    if (AdminLinks.Length > 0)
    {
        postAdminLinks = "<div class=\"post-adminlinks\">" + AdminLinks + "</div>";
    }
    var postUrl = Post.RelativeOrAbsoluteLink;
    var postTitle = Server.HtmlEncode(Post.Title);
    var postDate = Post.DateCreated.ToString("MMM dd, yyyy");
    var authorUrl = Utils.AbsoluteWebRoot + "author/" + Utils.RemoveIllegalCharacters(Post.Author + BlogConfig.FileExtension);
    var authorName = Post.AuthorProfile != null ? Utils.RemoveIllegalCharacters(Post.AuthorProfile.DisplayName) : Utils.RemoveIllegalCharacters(Post.Author);
    var postCategory = CategoryLinks(", ");
    var postTags = "<div class=\"post-tags\">" + TagLinks(", ") + "</div>";
    var postFirstImage = Post.FirstImgSrc;
    var postImageLink = "<a class=\"post-cover\" href=\"" + postUrl + "\"><img src=\"" + Post.FirstImgSrc + "\" alt=\"" + postTitle + "\"></a>";
    if (postFirstImage.Length < 1)
    {
        postClass += " no-thumbnail";
    }
    var blogLogo = "[CUSTOMFIELD|THEME|Standard|Publisher Logo|http://exampleblog.com/logo.png/]";
    var postImagePosition = "[CUSTOMFIELD|THEME|Standard|Post Thumbnail position|top/]";
%>

<% if (singlePost) { %>
<article class="post-single <%=postClass %>" id="post<%=Index %>">
    <!-- Text to Speech Button -->
    <button id="ttsButton" type="button" class="btn btn-outline-primary" onclick="speakPostContent()">Read Aloud</button>
    <header class="post-header">
        <h1 class="post-title"><%=postTitle %></h1>
        <div class="post-meta">
            <span class="post-author"><i class="fa fa-user"></i> <a href="<%=authorUrl %>"><%=authorName %></a></span>
            <span class="post-date"><i class="fa fa-clock-o"></i> <%=postDate %></span>
            <% if (postCategory.Length > 0) { %>
                <span class="post-category"><i class="fa fa-folder-open"></i> <%=postCategory %></span>
            <% } %>
            <div class="dropdown post-share float-md-right">
                <a class="dropdown-toggle" href="#" role="button" id="dropdownMenuLink" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                    <i class="fa fa-share-alt"></i><%=Resources.labels.share %>
                </a>
                <div class="dropdown-menu dropdown-menu-right" aria-labelledby="dropdownMenuLink">
                    <a class="dropdown-item item-fb" href="https://www.addtoany.com/add_to/facebook?linkurl=<%=Post.AbsoluteLink %>&amp;linkname=<%=postTitle %>" target="_blank"><i class="fa fa-facebook-square"></i>Facebook</a>
                    <a class="dropdown-item item-tw" href="https://www.addtoany.com/add_to/twitter?linkurl=<%=Post.AbsoluteLink %>&amp;linkname=<%=postTitle %>" target="_blank"><i class="fa fa-twitter-square"></i>Twitter</a>
                    <a class="dropdown-item item-gp" href="https://www.addtoany.com/add_to/google_plus?linkurl=<%=Post.AbsoluteLink %>&amp;linkname=<%=postTitle %>" target="_blank"><i class="fa fa-google-plus-square"></i>Google +</a>
                    <a class="dropdown-item item-ln" href="https://www.addtoany.com/add_to/linkedin?linkurl=<%=Post.AbsoluteLink %>&amp;linkname=<%=postTitle %>" target="_blank"><i class="fa fa-linkedin-square"></i>LinkedIn</a>
                    <a class="dropdown-item item-pi" href="https://www.addtoany.com/add_to/pinterest?linkurl=<%=Post.AbsoluteLink %>&amp;linkname=<%=postTitle %>" target="_blank"><i class="fa fa-pinterest-square"></i>Pinterest</a>
                    <a class="dropdown-item item-em" href="https://www.addtoany.com/add_to/email?linkurl=<%=Post.AbsoluteLink %>&amp;linkname=<%=postTitle %>" target="_blank"><i class="fa fa-envelope-square"></i>Email</a>
                    <a class="dropdown-item item-em" href="https://www.addtoany.com/share?linkurl=<%=Post.AbsoluteLink %>&amp;linkname=<%=postTitle %>" target="_blank"><i class="fa fa-plus-square"></i><%=Resources.labels.share %>...</a>
                </div>
            </div>
        </div>
    </header>
    <section class="post-body content-style">
        <asp:PlaceHolder ID="BodyContent" runat="server" />
    </section>
    <footer class="post-footer">
        <%=postTags %>
        <%=postAdminLinks %>
    </footer>
</article>
<script type="application/ld+json">
    {
      "@context": "http://schema.org",
      "@type": "NewsArticle",
      "mainEntityOfPage": {
        "@type": "WebPage",
        "@id": "<%=Post.AbsoluteLink %>"
      },
      "headline": "<%=postTitle %>",
      <% if (postFirstImage.Length > 1) { %>"image": "<%=Utils.AbsoluteWebRoot + postFirstImage.TrimStart(' ', '/') %>", <% } %>
      "datePublished": "<%=Post.DateCreated.ToString("yyyy-MM-dd") %>",
      "dateModified": "<%=Post.DateModified.ToString("yyyy-MM-dd") %>",
      "author": {
        "@type": "Person",
        "name": "<%=authorName %>"
      },
      "publisher": {
        "@type": "Organization",
        "name": "<%=BlogSettings.Instance.Name %>",
        "logo": {
          "@type": "ImageObject",
          "url": "<%= blogLogo %>"
        }
      },
      "description": "<%=Utils.RemoveHtmlWhitespace(Post.Description) %>"
    }
</script>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script type="text/javascript">
    function speakPostContent() {
        var msg = new SpeechSynthesisUtterance();
        var title = document.querySelector('.post-title').innerText;
        var content = document.querySelector('.post-body').innerText;
        msg.text = title + ". " + content;
        window.speechSynthesis.speak(msg);
    }

    // Sample data for the graphs, replace this with real data
    var postAnalytics = [
        { time: 30, readers: 15 },
        { time: 60, readers: 30 },
        { time: 90, readers: 10 },
        { time: 120, readers: 5 }
    ];

    var readersPerCountry = [
        { country: 'RSA', percentage: 40 },
        { country: 'ESwatini', percentage: 20 },
        { country: 'LeSotho', percentage: 15 },
        { country: 'Zimbabwe', percentage: 10 },
        { country: 'Mozambique', percentage: 8 },
        { country: 'Other', percentage: 7 }
    ];

    function drawAnalyticsGraph() {
        var ctx = document.getElementById('analyticsChart').getContext('2d');
        var labels = postAnalytics.map(function (item) { return item.time + "s"; });
        var data = postAnalytics.map(function (item) { return item.readers; });

        new Chart(ctx, {
            type: 'line',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Number of Readers',
                    data: data,
                    backgroundColor: 'rgba(75, 192, 192, 0.2)',
                    borderColor: 'rgba(75, 192, 192, 1)',
                    borderWidth: 1,
                    fill: false
                }]
            },
            options: {
                scales: {
                    y: {
                        beginAtZero: true,
                        title: {
                            display: true,
                            text: 'Number of Readers'
                        }
                    },
                    x: {
                        title: {
                            display: true,
                            text: 'Time Spent (seconds)'
                        }
                    }
                }
            }
        });
    }

    function drawCountryGraph() {
        var ctx = document.getElementById('countryChart').getContext('2d');
        var labels = readersPerCountry.map(function (item) { return item.country; });
        var data = readersPerCountry.map(function (item) { return item.percentage; });

        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Readers per Country (%)',
                    data: data,
                    backgroundColor: 'rgba(54, 162, 235, 0.2)',
                    borderColor: 'rgba(54, 162, 235, 1)',
                    borderWidth: 1
                }]
            },
            options: {
                scales: {
                    y: {
                        beginAtZero: true,
                        title: {
                            display: true,
                            text: 'Percentage of Readers (%)'
                        }
                    },
                    x: {
                        title: {
                            display: true,
                            text: 'Countries'
                        }
                    }
                }
            }
        });
    }

    window.onload = function () {
        console.log("Window loaded, drawing graphs...");
        drawAnalyticsGraph();
        drawCountryGraph();
    };
</script>

<canvas id="analyticsChart" width="400" height="200"></canvas>
<canvas id="countryChart" width="400" height="200"></canvas>

<% } %>
