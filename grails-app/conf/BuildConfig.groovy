grails.servlet.version = "3.0" // Change depending on target container compliance (2.5 or 3.0)
grails.project.class.dir = "target/classes"
grails.project.test.class.dir = "target/test-classes"
grails.project.test.reports.dir = "target/test-reports"
grails.project.work.dir = "target/work"
grails.project.target.level = 1.6
grails.project.source.level = 1.6
grails.project.war.file = "target/${appName}.war"

// grails.plugin.location.'ala-web-theme' = "../ala-web-theme"

grails.project.fork = [
    // configure settings for compilation JVM, note that if you alter the Groovy version forked compilation is required
    //  compile: [maxMemory: 256, minMemory: 64, debug: false, maxPerm: 256, daemon:true],

    // configure settings for the test-app JVM, uses the daemon by default
    test: none,
    // configure settings for the run-app JVM
    run: none,
    // configure settings for the run-war JVM
    war: none,
    // configure settings for the Console UI JVM
    console: none
]

grails.project.dependency.resolver = "maven" // or ivy
grails.project.dependency.resolution = {
    // inherit Grails' default dependencies
    inherits("global") {
        // specify dependency exclusions here; for example, uncomment this to disable ehcache:
        // excludes 'ehcache'
    }
    log "error" // log level of Ivy resolver, either 'error', 'warn', 'info', 'debug' or 'verbose'
    checksums true // Whether to verify checksums on resolve
    legacyResolve false // whether to do a secondary resolve on plugin installation, not advised and here for backwards compatibility

    repositories {
        mavenLocal()
        mavenRepo("http://nexus.ala.org.au/content/groups/public/") {
            updatePolicy 'always'
        }
    }

    dependencies {
        // specify dependencies here under either 'build', 'compile', 'runtime', 'test' or 'provided' scopes e.g.
        runtime 'org.postgresql:postgresql:9.3-1101-jdbc41'

        test "org.grails:grails-datastore-test-support:1.0.2-grails-2.4"

        compile 'net.sf.ehcache:ehcache:2.8.4'
        compile 'com.github.rjeschke:txtmark:0.11'
        compile('ognl:ognl:3.0.8') {
            excludes('javassist:javassist:3.11.0.GA')
        }
        compile 'org.elasticsearch:elasticsearch:1.4.4'
        compile 'com.vividsolutions:jts:1.13'
    }

    plugins {
        build ":release:3.0.1"
        // plugins for the build system only
        build ":tomcat:7.0.55"

        // plugins for the compile step
        compile ":scaffolding:2.1.2"
        compile ':cache:1.1.8'
        // compile ":asset-pipeline:1.9.9"

        // plugins needed at runtime but not for compilation
        runtime ":hibernate4:4.3.6.1"
        runtime ":database-migration:1.4.0"
        //runtime ":jquery:1.11.1"

        runtime ":ala-bootstrap2:2.1"
        runtime(":ala-auth:1.3-SNAPSHOT") {
            excludes "servlet-api"
        }
        runtime ":images-client-plugin:0.2.2"

        compile ":quartz:1.0.2"

        // Uncomment these to enable additional asset-pipeline capabilities
        //compile ":sass-asset-pipeline:1.9.0"
        // compile ":less-asset-pipeline:1.10.0"
        //compile ":coffee-asset-pipeline:1.8.0"
        //compile ":handlebars-asset-pipeline:1.3.0.3"
    }
}
