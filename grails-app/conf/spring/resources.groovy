import au.org.ala.taxonoverflow.CustomJSONMarshallers
import au.org.ala.taxonoverflow.notification.NotificationsAspect
import org.springframework.aop.aspectj.annotation.AnnotationAwareAspectJAutoProxyCreator

// Place your Spring DSL code here
beans = {
    xmlns aop:"http://www.springframework.org/schema/aop"

    aspectBean(NotificationsAspect)
    autoProxyCreator(AnnotationAwareAspectJAutoProxyCreator) {
        proxyTargetClass = true
    }

    customJSONMarshallers(CustomJSONMarshallers) {
        biocacheService = ref("biocacheService")
        ecodataService = ref("ecodataService")
    }


}
