<%@ page import="au.org.ala.taxonoverflow.AnswerComment" %>
<style>
body {
    font-family: Arial,sans-serif;
    color: #637073;
    font-size: 14px;
}

blockquote {
    font-family: Georgia, sans-serif;
    font-size: 14px;
    font-style: italic;
    width: 500px;
    margin: 0.5em 0;
    padding: 0.5em 40px;
    line-height: 1.45;
    position: relative;
    color: #383838;
}

blockquote:before {
    display: block;
    content: "\201C";
    font-size: 50px;
    position: absolute;
    color: #7a7a7a;
    left: -3px;
    top: -7px;
}
</style>
<p>${userDetails.displayName} posted the following${comment instanceof AnswerComment ? ' identification' : ''} comment about question #${comment instanceof AnswerComment ? comment.answer.question.id : comment.question.id} on Taxon-Overflow</p>
<blockquote>
   ${comment.comment}
</blockquote>
