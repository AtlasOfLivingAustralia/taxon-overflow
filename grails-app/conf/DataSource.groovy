import org.hibernate.cache.ehcache.SingletonEhCacheRegionFactory

dataSource {
    pooled = true
    jmxExport = true

}

hibernate {
    cache.use_second_level_cache = true
    cache.use_query_cache = false
    cache.region.factory_class = SingletonEhCacheRegionFactory.canonicalName // Hibernate 4
}

// environment specific settings
environments {

    development {
        dataSource {
            dbCreate = "update" // one of 'create', 'create-drop','update'
            username="postgres"
            password="password"
            url = "jdbc:postgresql://localhost/taxonoverflow"
            driverClassName = "org.postgresql.Driver"
            loggingSql = false
        }
    }

    test {
        dataSource {
            dbCreate = "update" // one of 'create', 'create-drop','update'
            username="sa"
            password=""
            url = "jdbc:h2:mem:testDb:MVCC=true;LOCK_TIMEOUT=5000"
            driverClassName = "org.h2.Driver"
            loggingSql = true
        }
    }

    production {
        dataSource {
            dbCreate = "update"
            testOnBorrow = true
            url = "jdbc:postgresql://localhost/taxonoverflow"
            driverClassName = "org.postgresql.Driver"
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
