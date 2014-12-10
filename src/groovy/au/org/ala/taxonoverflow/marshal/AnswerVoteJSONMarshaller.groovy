package au.org.ala.taxonoverflow.marshal

import au.org.ala.taxonoverflow.AnswerVote

class AnswerVoteJSONMarshaller extends AbstractJSONMarshaller<AnswerVote> {

    @Override
    protected void marshalObject(AnswerVote vote, Map result) {
        result.user = vote.user
        result.answerId = vote.answer.id
        result.voteValue = vote.voteValue
        result.dateCreated = formatDate(vote.dateCreated)
        result.dateUpdated = formatDate(vote.dateUpdated)
    }

    @Override
    protected Class<AnswerVote> getWrappedClass() {
        return AnswerVote
    }
}
