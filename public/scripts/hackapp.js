/**
 * Control bindings - link controls to actions within javascript application
 * e.g. Update button invokes a refresh of values and displays the,
 */

function displaySuggestion(suggestion) {
    var displayText = suggestion.acronym + ": " + suggestion.suggestion;
    $("#AcronymResult").text(displayText);
    $("#AcronymResult").show();
}


function queryServer(restUrl) {
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
	
function getSuggestions() {
		var acronym = $("#AcronymInput").val();
        queryServer("/" + acronym);
}


jQuery(document).ready(function(event) {
    $("#AcronymSubmit").click(function() {
        getSuggestions();
    });
	
	$(document).on("keypress", "#AcronymInput", function(e) {
		if (e.which == 13) {
		 getSuggestions();
		}
	});
});

