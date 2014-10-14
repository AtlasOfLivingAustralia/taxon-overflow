package au.org.ala.taxonoverflow

class Identification {

    Subject subject
    User user
    Date dateCreated
    int votes
    // Below only one of the following should be not empty...
    String taxonGUID // from bie
    String binomial // handles scientific names that could not be matched in the BIE
    String commonName // catch all

    static constraints = {
    }
}
