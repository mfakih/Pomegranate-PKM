dataSource {
    pooled = true
    logSql = false
    testConnectionOnCheckout = true
    testConnectionOnCheckin = true
}

hibernate {
    cache.use_second_level_cache = true
    cache.use_query_cache = true
    hibernate.connection.useUnicode = true
    hibernate.connection.characterEncoding = "UTF-8"
    cache.region.factory_class = 'net.sf.ehcache.hibernate.EhCacheRegionFactory'
}

// environments: dev, prod, ext
environments {

    development {
        dataSource {
            driverClassName = "com.mysql.jdbc.Driver"
            username = "root"
            password = "root"
            dialect = org.hibernate.dialect.MySQL5InnoDBDialect
            dbCreate = "update" // one of 'create', 'create-drop','update'
            url = "jdbc:mysql://localhost:3306/db_pkm_tracker"
        }
    }


    h2 {
        dataSource {
            dbdir = "${System.properties['catalina.base'] ?: '.'}/database/db_pkm"
//            dbdir = "./database/pkm"
            dialect = org.hibernate.dialect.H2Dialect
            driverClassName = "org.h2.Driver"
            testConnectionOnCheckout = true
            testConnectionOnCheckin = true

            dbCreate = "update"
            url = "jdbc:h2:file:${dbdir};MVCC=TRUE;LOCK_TIMEOUT=10000;MODE=MySQL;IGNORECASE=TRUE;"
            pooled = true
            username = "admin"
            password = "admin"

            properties {
                maxActive = -1
                minEvictableIdleTimeMillis = 1800000
                timeBetweenEvictionRunsMillis = 1800000
                numTestsPerEvictionRun = 3
                testOnBorrow = true
                testWhileIdle = true
                testOnReturn = true
                validationQuery = "SELECT 1"
            }

        }
    }
  h22 {
        dataSource {
            dbdir = "${System.properties['catalina.base'] ?: '.'}/database/db_pkm2"
//            dbdir = "./database/pkm"
            dialect = org.hibernate.dialect.H2Dialect
            driverClassName = "org.h2.Driver"
            testConnectionOnCheckout = true
            testConnectionOnCheckin = true

            dbCreate = "update"
            url = "jdbc:h2:file:${dbdir};MVCC=TRUE;LOCK_TIMEOUT=10000;MODE=MySQL;IGNORECASE=TRUE;"
            pooled = true
            username = "admin"
            password = "admin"

            properties {
                maxActive = -1
                minEvictableIdleTimeMillis = 1800000
                timeBetweenEvictionRunsMillis = 1800000
                numTestsPerEvictionRun = 3
                testOnBorrow = true
                testWhileIdle = true
                testOnReturn = true
                validationQuery = "SELECT 1"
            }
        }
    }

    production {
        dataSource {
            dbCreate = "update"
            driverClassName = "com.mysql.jdbc.Driver"
            jndiName = "java:comp/env/jdbc/db_pkm_prod"
            pooled = true
            properties {
                maxActive = -1
                minEvictableIdleTimeMillis = 1800000
                timeBetweenEvictionRunsMillis = 1800000
                numTestsPerEvictionRun = 3
                testOnBorrow = true
                testWhileIdle = true
                testOnReturn = true
                validationQuery = "SELECT 1"
            }
        }
    }

    mysql {
        dataSource {
            dbCreate = "update"
            driverClassName = "com.mysql.jdbc.Driver"
            jndiName = "java:comp/env/jdbc/db_pkm_prod"
            pooled = true
            properties {
                maxActive = -1
                minEvictableIdleTimeMillis = 1800000
                timeBetweenEvictionRunsMillis = 1800000
                numTestsPerEvictionRun = 3
                testOnBorrow = true
                testWhileIdle = true
                testOnReturn = true
                validationQuery = "SELECT 1"
            }
        }
    }

    mysql2 {
        dataSource {
            dbCreate = "update"
            driverClassName = "com.mysql.jdbc.Driver"
            jndiName = "java:comp/env/jdbc/db_pkm_prod2"
            pooled = true
            properties {
                maxActive = -1
                minEvictableIdleTimeMillis = 1800000
                timeBetweenEvictionRunsMillis = 1800000
                numTestsPerEvictionRun = 3
                testOnBorrow = true
                testWhileIdle = true
                testOnReturn = true
                validationQuery = "SELECT 1"
            }
        }
    }
}