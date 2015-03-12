package au.org.ala.taxonoverflow.notification

import java.lang.annotation.ElementType
import java.lang.annotation.Retention
import java.lang.annotation.RetentionPolicy
import java.lang.annotation.Target

/**
 * Created by rui008 on 5/03/15.
 */

@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.METHOD)
@interface SendEmailNotification {

}