dataSource {
	pooled = true
    driverClassName = "com.mysql.jdbc.Driver"
    username = "grails"
    password = "server"
    logSql = false
}
hibernate {
    cache.use_second_level_cache=true
    cache.use_query_cache=true
    cache.provider_class='net.sf.ehcache.hibernate.EhCacheProvider'
}
// environment specific settings
environments {
	development {
		dataSource {
//            logSql = "true"
            dialect = org.hibernate.dialect.MySQL5InnoDBDialect
			dbCreate = "update" // one of 'create', 'create-drop','update'
            url = "jdbc:mysql://localhost:3306/coll?autoReconnect=true&connectTimeout=0"
//			url = "jdbc:hsqldb:mem:devDB"
		}
	}
	test {
		dataSource {
			dbCreate = "create"
			url = "jdbc:hsqldb:mem:testDb"
            driverClassName = "org.hsqldb.jdbcDriver"
            username = "sa"
            password = ""
		}
	}
	testserver {
        dataSource {
            dialect = org.hibernate.dialect.MySQL5InnoDBDialect
            dbCreate = "update"
            url = "jdbc:mysql://alatstweb1-cbr.vm.csiro.au:3306/collectory?autoReconnect=true&connectTimeout=0"
            logSql = false
            properties {
                maxActive = 50
                maxIdle = 25
                minIdle = 5
                initialSize = 5
                minEvictableIdleTimeMillis = 60000
                timeBetweenEvictionRunsMillis = 60000
                maxWait = 10000
                validationQuery = "/* ping */"
            }
        }
	}
	production {
		dataSource {
            dialect = org.hibernate.dialect.MySQL5InnoDBDialect
			dbCreate = "update"
			url = "jdbc:hsqldb:file:prodDb;shutdown=true"
			//url = "jdbc:mysql://alaproddb1-cbr.vm.csiro.au:3306/collectory?autoReconnect=true&connectTimeout=0"//"jdbc:hsqldb:file:prodDb;shutdown=true"
            logSql = false
            properties {
                maxActive = 50
                maxIdle = 25
                minIdle = 5
                initialSize = 5
                minEvictableIdleTimeMillis = 60000
                timeBetweenEvictionRunsMillis = 60000
                maxWait = 10000
                validationQuery = "/* ping */"
            }
		}
	}
}