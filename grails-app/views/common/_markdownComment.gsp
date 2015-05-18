<g:if test="${label}">
<label for="${name}" class="col-md-2 control-label">${label}</label>
</g:if>
<div class="col-md-${label ? '10' : '12'} col-sm-${label ? '10' : '12'} markdown-field">
    <div class="panel with-nav-tabs panel-default">
        <div class="pull-right">
            <a href="http://daringfireball.net/projects/markdown/syntax" class="markdown-syntax-link" title="Markdown Syntax" target="_blank"><span class="octicon octicon-markdown"></span> Markdown syntax supported</a>
        </div>
        <div class="panel-heading">
            <ul class="nav nav-tabs toggle-markdown">
                <li role="presentation" class="active"><a href="#"><i class="fa fa-pencil"></i> Comment</a></li>
                <li role="presentation"><a href="#"><i class="fa fa-eye"></i> Preview</a></li>
            </ul>
        </div>
        <div class="panel-body">
            <div class="textarea-edit">
                <g:textArea class="form-control" name="${name}" placeholder="${placeholder}" rows="${rows}"></g:textArea>
            </div>
            <div class="textarea-preview hidden">

            </div>
        </div>
    </div>



</div>