<%@ page import="org.codehaus.groovy.grails.commons.ConfigurationHolder; au.org.ala.collectory.ProviderGroup" %>
<html>
    <head>
        <title><g:message code="admin.home.title" /></title>
	<meta name="layout" content="${grailsApplication.config.ala.skin}" />

    </head>
    
    <body>

        <div id="nav">
            <ul id="nav-primary" class="left">
                  <li class="nav-item active">
                          <g:link controller="admin" action="home" class="active" accesskey="2"><g:message code="admin.home.li01" /></g:link>
                  </li>
            </ul>
            <ul id="nav-secondary" class="right">
                  <li class="nav-item">
                          <a href="${ConfigurationHolder.config.ala.baseURL}" accesskey="3"><g:message code="admin.home.li02" /></a>
                  </li>
                  <li class="nav-item">
                          <a href="${ConfigurationHolder.config.grails.serverURL}" accesskey="4"><g:message code="admin.home.li03" /></a>
                  </li>
                  <li class="nav-item">
                      <cl:isLoggedIn>
                          <a href="http://auth.ala.org.au/cas/logout?url=${ConfigurationHolder.config.grails.serverURL}/admin/home"><g:message code="admin.logout" /></a>
                      </cl:isLoggedIn>
                      <cl:isNotLoggedIn>
                          <a href="http://auth.ala.org.au/cas/login?service=${ConfigurationHolder.config.security.cas.serverName}/${ConfigurationHolder.config.security.cas.context}/admin"><g:message code="admin.login" /></a>
                      </cl:isNotLoggedIn>
                  </li>
            </ul>
        </div>

        <div class="login-info">
            <cl:isLoggedIn>
                <span id="logged-in"><g:message code="admin.loggedin" /> <cl:loggedInUsername/></span>
            </cl:isLoggedIn>
        </div>


      <div class="floating-content">

          <!--div style="float:right;">
            <g:link class="mainLink" controller="public" action="map">View public site</g:link>
          </div-->
          <div id="welcome">
              <img width="130" height="109" src="${resource(dir:'images/admin',file:'swift-moth.gif')}"/>
              <div>
                  <span style="font-size:12px;"><g:message code="admin.home.welcome.span01" /></span>
                    <h1><g:message code="admin.home.welcome.title01" /></h1>
                    <p><g:message code="admin.home.welcome.des01" />.</p>
              </div>
          </div>

          <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
          </g:if>

          <cl:isNotLoggedIn>
            <div class="homeCell">
              <h4 class="inline"><g:message code="admin.home.welcome.title02" /></h4>
                <span style="" class="buttons" style="float: right;">
                  <a href="${ConfigurationHolder.config.security.cas.loginUrl}?service=${ConfigurationHolder.config.grails.serverURL}/admin">&nbsp;<g:message code="admin.home.welcome.link01" />&nbsp;</a>
                </span>
              <p><g:message code="admin.home.welcome.des02" /></p>
            </div>
          </cl:isNotLoggedIn>
          <div style="clear:both;"></div>

          <div id="buttons">
          <div class='link-group'>
              <h2><g:message code="admin.home.buttons.title01" /></h2>
              <g:link class="mainLink" controller="collection" action="list"><g:message code="admin.home.buttons.link01" /></g:link>
              <g:link class="mainLink" controller="collection" action="myList" id="68"><g:message code="admin.home.buttons.link02" /></g:link>
              <g:link class="mainLink" controller="collection" action="create-notyet"><g:message code="admin.home.buttons.link03" /></g:link>
              <span><g:message code="admin.home.buttons.span01" /></span>
              <g:form action="search">
                <g:textField class="mainText" name="term"/><span class="search-button-wrapper">
                  <g:actionSubmitImage width="24" src="${resource(dir:'images/admin',file:'search.png')}" action="search" value="Search"/></span>
              </g:form>
          </div>

          <div class='link-group'>
              <h2><g:message code="admin.home.buttons.title02" /></h2>
              <g:link class="mainLink" controller="institution" action="list"><g:message code="admin.home.buttons.link04" /></g:link>
              <g:link class="mainLink" controller="institution" action="myList" id="68"><g:message code="admin.home.buttons.link05" /></g:link>
              <g:link class="mainLink" controller="institution" action="create-notyet"><g:message code="admin.home.buttons.link06" /></g:link>
              <span><g:message code="admin.home.buttons.span02" /></span>
              <g:form action="search">
                <g:textField class="mainText" name="term"/><span class="search-button-wrapper">
                  <g:actionSubmitImage src="${resource(dir:'images/admin',file:'search.png')}" action="search" value="Search"/></span>
              </g:form>
          </div>


          <div class='link-group'>
              <h2><g:message code="admin.home.buttons.title03" /></h2>
              <g:link class="mainLink" controller="dataResource" action="list"><g:message code="admin.home.buttons.link07" /></g:link>
              <g:link class="mainLink" controller="dataProvider" action="list"><g:message code="admin.home.buttons.link08" /></g:link>
              <g:link class="mainLink" controller="institution" action="create-notyet"><g:message code="admin.home.buttons.link09" /></g:link>
              <span><g:message code="admin.home.buttons.span03" /></span>
              <g:form action="search">
                <g:textField class="mainText" name="term"/><span class="search-button-wrapper">
                  <g:actionSubmitImage src="${resource(dir:'images/admin',file:'search.png')}" action="search" value="Search"/></span>
              </g:form>
          </div>

          <div class='link-group'>
              <h2><g:message code="admin.home.buttons.title04" /></h2>
              <g:link class="mainLink" controller="contact" action="showProfile"><g:message code="admin.home.buttons.link10" /></g:link>
              <p class="mainText"><g:message code="admin.home.buttons.des01" />.</p>
          </div>

          <g:if test="${request.isUserInRole(ProviderGroup.ROLE_ADMIN)}">

          <div class='link-group admin'>
              <h2><g:message code="admin.home.buttons.title05" /></h2>
              <g:link class="mainLink" controller="reports" action="home"><g:message code="admin.home.buttons.link11" /></g:link>
              <g:link class="mainLink" controller="contact" action="list"><g:message code="admin.home.buttons.link12" /></g:link>
              <g:link class="mainLink" controller="admin" action="export"><g:message code="admin.home.buttons.link13" /></g:link>
          </div>

          <div class='link-group admin'>
              <h2><g:message code="admin.home.buttons.title06" /></h2>
              <g:link class="mainLink" controller="providerCode" action="list"><g:message code="admin.home.buttons.link14" /></g:link>
              <p class="mainText"><g:message code="admin.home.buttons.link15" />.</p>
              <g:link class="mainLink" controller="providerMap" action="list"><g:message code="admin.home.buttons.link16" /></g:link>
              <p class="mainText"><g:message code="admin.home.buttons.link17" />.</p>
          </div>
          </g:if>
        </div>

        <div style="clear: both;"></div>

      </div>
      <script type="text/javascript">
          $('.link-group').hover(
                  function() {
                      $(this).addClass('link-group-highlight');
                  },
                  function() {
                      $(this).removeClass('link-group-highlight');
                  }
          );
      </script>
    </body>
</html>