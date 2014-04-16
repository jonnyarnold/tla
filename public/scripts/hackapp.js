/**
 * Control bindings - link controls to actions within javascript application
 * e.g. Update button invokes a refresh of values and displays the,
 */

function displaySuggestion(suggestion) {
    var displayText = suggestion.acronym + ": " + suggestion.suggestion;
    $("#AcronymResult").text(displayText);
    $("#AcronymResult").show();
}


function getSuggestion(restUrl) {
    $.ajax({
            url: restUrl,
            type: 'GET',
            dataType: 'json',
            success: function(suggestion) {
                displaySuggestion(suggestion);
            },
            error: function(xhr, status, error) {
                console.log(eval(xhr.responseText));
            }
        });
    }


jQuery(document).ready(function(event) {
    $("#AcronymSubmit").click(function() {
        var acronym = $("#AcronymInput").val();
        var restUrl = "http://localhost:4567/" + acronym;
        getSuggestion(restUrl);
    });
});

