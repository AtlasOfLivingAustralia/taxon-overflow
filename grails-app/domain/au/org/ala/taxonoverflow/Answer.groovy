package au.org.ala.taxonoverflow

import grails.converters.JSON
import groovy.json.JsonSlurper

/**
 * An answer to a question in taxonoverflow. This will consist of 2 things:
 *
 * 1) a map of darwin core properties giving an answer
 * 2) a description
 */
class Answer {

    User user
    Date dateCreated
    boolean accepted
    Date dateAccepted

    // JSON map of darwin core properties with values
    String darwinCore

    String description // Descriptive/free text for an answer

    static belongsTo = [question: Question]

    static hasMany = [votes: AnswerVote, comments: AnswerComment]

    static constraints = {
        question nullable: false
        user column: "taxonoverflow_user", nullable: false
        description nullable: true
        darwinCore nullable: true
        dateAccepted nullable: true
    }

    static mapping = {
        comments sort: 'dateCreated', order: 'asc'
        darwinCore type: 'text'
    }

    def afterUpdate() {
        IndexHelper.indexQuestion(this.question.id)
    }

    def afterInsert() {
        IndexHelper.indexQuestion(this.question.id)
    }

    def afterDelete() {
        IndexHelper.indexQuestion(this.question.id)
    }
}

