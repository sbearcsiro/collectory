<%@ page contentType="text/html;charset=UTF-8" %>
<html>
  <head>
    <title>Redirect (workaround)</title>
    <!-- note: the redirect url needs to be /Collectory/institution/... if the access
         url has the Collectory context but just /institution/.. if the access url is
         a sub-domain that transparently redirects to the context. -->
    <meta http-equiv="refresh" content="0;url=${url}/${id}"/>
    <META HTTP-EQUIV="EXPIRES" CONTENT="0">
    <META HTTP-EQUIV="PRAGMA" CONTENT="NO-CACHE">
  </head>
  <body>Redirecting</body>
</html>