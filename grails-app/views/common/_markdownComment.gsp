<label for="${name}" class="col-md-2 control-label">${label}</label>
<div class="col-sm-10 markdown-field">
    <div class="btn-group" id="comment-preview" role="group" aria-label="toggle-preview">
        <button class="btn btn-default btn-sm active"><i class="fa fa-pencil"></i> Text</button>
        <button class="btn btn-default btn-sm"><i class="fa fa-eye"></i> Preview</button>
    </div>
    <div class="textarea-edit">
        <g:textArea class="form-control" name="${name}" placeholder="${placeholder}" rows="${rows}"></g:textArea>
        <span class="help-block">* This field supports <a href="http://daringfireball.net/projects/markdown/syntax" title="Markdown Syntax" target="_blank">Markdown</a> format.</span>
    </div>
    <div class="textarea-preview hidden">

    </div>
</div>