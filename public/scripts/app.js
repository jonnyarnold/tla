function TlaViewModel() {
    var self = this;

    // Establish modeol properties
    self.acronym = ko.observable();
    self.suggestion = ko.observable();
    self.twitterUrl = ko.observable();

    // Custom subscription to the acronym model property
    // that is invoked any time it changes, via code or 
    // because the user updates it in the DOM. Fetches
    // a suggestion from the server if input is at least
    // 2 characters long.
    self.acronym.subscribe(function(input) {
        if (input.length > 1) {
            $.get("/" + self.acronym(), self.suggestion); 
        } else {
            self.suggestion("");
        }
     });

    // Capitalises the acronym
    self.capitalAcronym = ko.computed(function() {
        var lowerAcronym = self.acronym();
        if (lowerAcronym !== undefined) return lowerAcronym.toUpperCase();
        else return "";
    });

    // Result bound variable will update if suggestion updates.
    // This is then propogated to the DOM via binding.
    self.result = ko.computed(function() { 
        return self.capitalAcronym.peek() + ": " + self.suggestion();
    });

    // Sets the twitter target url. If no suggestion exists,
    // a default message is placed in instead.
    self.twitterUrl = ko.computed(function() {
        var url = window.location.origin;

        if (self.suggestion()) {
            var tweetText = self.result();
        } else {
            var tweetText = "TLA! Three Letter Acronyms, just for you.";
        }
        
        return "https://twitter.com/intent/tweet" +
            "?hashtags=" + "TLA" +
            "&url=" + encodeURIComponent(url) +
            "&text=" + tweetText;
    });

    self.onKeypress = function(data, event) {
        // Force re-evaluation on 'enter'
        if (event.keyCode == 13) self.acronym.valueHasMutated();
        return true;
    }
}

jQuery(document).ready(function() {
    ko.applyBindings(TlaViewModel());

    $("#AcronymInput").on('input', function(evt) {
        var input = $(this);
        var start = input[0].selectionStart;
        $(this).val(function (_, val) {
            val = val.replace(/[^A-Za-z]/g, '');
            return val.toUpperCase();
        });
        input[0].selectionStart = input[0].selectionEnd = start;
    });

});

function hover(element) {
    element.setAttribute('src', 'styles/images/twitter_hover.png');
}
function unhover(element) {
    element.setAttribute('src', 'styles/images/twitter.png');
}
