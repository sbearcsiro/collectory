import org.apache.commons.dbcp.BasicDataSource

// Place your Spring DSL code here
beans = {
    datasource(BasicDataSource) {
        // run evictor every 30 minutes and evict any connections older than 30 minutes.
        minEvictableIdleTimeMillis=1800000
        timeBetweenEvictionRunsMillis=1800000
        numTestsPerEvictionRun=3
        // test the connection while it's idle
        testOnBorrow=true
        testWhileIdle=true
        testOnReturn=true
        validationQuery="SELECT 1"
    }
}