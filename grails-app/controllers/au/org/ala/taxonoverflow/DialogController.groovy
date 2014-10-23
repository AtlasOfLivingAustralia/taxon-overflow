package au.org.ala.taxonoverflow

class DialogController {

    def areYouSureFragment() {
        def message = params.message
        def affirmativeText = params.affirmativeText ?: "Yes"
        def negativeText = params.negativeText ?: "No"

        [message: message, affirmativeText: affirmativeText, negativeText: negativeText]
    }

    def pleaseWaitFragment() {
        [message: params.message ?: "Please wait..."]
    }

}
