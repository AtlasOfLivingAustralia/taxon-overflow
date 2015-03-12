dataSource {
    pooled = true
    jmxExport = true
    driverClassName = "org.postgresql.Driver"
}

hibernate {
    cache.use_second_level_cache = true
    cache.use_query_cache = false
//    cache.region.factory_class = 'net.sf.ehcache.hibernate.EhCacheRegionFactory' // Hibernate 3
    cache.region.factory_class = 'org.hibernate.cache.ehcache.EhCacheRegionFactory' // Hibernate 4
    singleSession = true // configure OSIV singleSession mode
    flush.mode = 'manual' // OSIV session flush mode outside of transactional context
}

// environment specific settings
environments {

    development {
        dataSource {
            dbCreate = "update" // one of 'create', 'create-drop','update'
            username="mar759"
            password=""
            url = "jdbc:postgresql://localhost/taxonoverflow"
            loggingSql = false
        }
    }

    test {
        dataSource {
            dbCreate = "update" // one of 'create', 'create-drop','update'
            username="postgres"
            password="password"
            url = "jdbc:postgresql://localhost/taxonoverflow"
            loggingSql = false
        }
    }

    production {
        dataSource {
            dbCreate = "update"
            testOnBorrow = true
            url = "jdbc:postgresql://localhost/taxonoverflow"
            properties {
                maxActive = 10
                maxIdle = 5
                minIdle = 5
                initialSize = 5
                minEvictableIdleTimeMillis = 60000
                timeBetweenEvictionRunsMillis = 60000
                maxWait = 10000
                validationQuery = "select max(id) from image"
            }
        }
    }

}
