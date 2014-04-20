/**
 * Control bindings - link controls to actions within javascript application
 * e.g. Update button invokes a refresh of values and displays the,
 */


/******************************
 * Data feetching and display *
 ******************************/

function displaySuggestion(suggestion) {
    var displayText = suggestion.acronym + ": " + suggestion.suggestion;
    $("#AcronymResult").text(displayText);
    $("#AcronymResult").show();
    $('#tweet').attr('href', generateTweetUrl(displayText))
}

// Creates a Twitter Share URL for use on a Tweet button
// as documented @ https://dev.twitter.com/docs/tweet-button
function generateTweetUrl(tla) {
    url = window.location.origin
    tweetText = tla; // Twitter adds URL automatically

    return "https://twitter.com/intent/tweet" +
        "?hashtags=" + "TLA" +
        "&url=" + url +
        "&text=" + tweetText + 
        "#TLA";
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


/************************
 * Responsive behaviour *
 ************************/

function setResponsivePlaceholderText() {
    if ($(window).width() < 800){
        $('#AcronymInput').attr('placeholder','Enter TLA...');
     } else {
        $('#AcronymInput').attr('placeholder','Enter your acronym!');
    }
}


/*************************************
 * Attaching listeners and init page *
 *************************************/

jQuery(document).ready(function(event) {
    $("#AcronymSubmit").click(function() {
        getSuggestions();
    });
    
    $(document).on("keypress", "#AcronymInput", function(e) {
        if (e.which == 13) {
         getSuggestions();
        }
    });

    setResponsivePlaceholderText();

    $(window).resize(function() {
        setResponsivePlaceholderText();
    });
});

