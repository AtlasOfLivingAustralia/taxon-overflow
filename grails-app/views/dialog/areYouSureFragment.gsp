<div>
    <p>
    ${message}
    </p>
    <div class="form-horizontal">
        <div class="control-group">
            <button id="btnNo" class="btn">${negativeText}</button>
            <button id="btnYes" class="btn">${affirmativeText}</button>
        </div>
    </div>
</div>
<script>

    $("#btnYes").click(function(e) {
        e.preventDefault();
        if (tolib.areYouSureOptions && tolib.areYouSureOptions.affirmativeAction) {
            tolib.areYouSureOptions.affirmativeAction();
        }
        tolib.hideModal();
    });

    $("#btnNo").click(function(e) {
        e.preventDefault();
        if (tolib.areYouSureOptions && tolib.areYouSureOptions.negativeAction) {
            tolib.areYouSureOptions.negativeAction();
        }
        tolib.hideModal();
    });

</script>