<%@ page import="org.codehaus.groovy.grails.commons.ConfigurationHolder; java.text.DecimalFormat; java.text.SimpleDateFormat" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="${ConfigurationHolder.config.ala.skin}" />
        <title>${fieldValue(bean: instance, field: "name")} | Data sets | Atlas of Living Australia</title>
    </head>
    <body class="two-column-right">
      <div id="content">
        <div id="header" class="collectory">
          <!--Breadcrumbs-->
          <div id="breadcrumb"><cl:breadcrumbTrail home="dataSets"/>
            ${fieldValue(bean: instance, field: "name")}
          </div>
          <div class="section full-width">
            <div class="hrgroup col-8">
              <cl:h1 value="${instance.name}"/>
            </div>
            <div class="aside col-4 center">
              <!-- provider -->
            </div>
          </div>
        </div><!--close header-->
        <div id="column-one">
          <div class="section">
            <g:set var="name" value="${[instance.firstName, instance.lastName].join(' ')}"/>
            <g:if test="${!name}">
              <g:set var="name" value="${instance.email}"/>
            </g:if>
            <p>This data set is a temporary set of records that has been uploaded to the sandbox by ${name}
            on ${instance.dateCreated}.</p>
            <p>The data set contains ${instance.numberOfRecords} records.</p>
            <cl:lastUpdated date="${instance.lastUpdated}"/>
          </div>
        </div><!--close column-one-->

        <div id="column-two">
          <div class="section sidebar">

            <div class="section">
              <p>${fieldValue(bean: instance, field: "firstName")} ${fieldValue(bean: instance, field: "lastName")}</p>
              <g:if test="${instance.email}"><cl:emailLink>${fieldValue(bean: instance, field: "email")}</cl:emailLink><br/></g:if>
            </div>

          </div>
        </div>
      </div>

    </body>
</html>
