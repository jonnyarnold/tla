function TlaViewModel() {
    var self = this;
    self.siteDescription = "TLA! Three Letter Acronyms, just for you.";

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

    // The text to be set as the default in social media postings.
    self.socialMediaComment = ko.computed(function() {
        if (self.suggestion()) {
            return self.result();
        } else {
            return self.siteDescription;
        }
    });

    self.twitterUrl = ko.computed(function() {
        var url = window.location.origin;

        return "https://twitter.com/intent/tweet" +
            "?hashtags=" + "TLA" +
            "&url=" + encodeURIComponent(url) +
            "&text=" + self.socialMediaComment();
    });

    self.facebookUrl = ko.computed(function() {
        var url = window.location.origin;

        // Note that Facebook doesn't play well with localhost
        // when you're on development. To see what will actually
        // be shown, copy the link URL and replace localhost:4567
        // with the production URL.
        return "https://www.facebook.com/dialog/feed?" +
            "app_id=1416309778636759" +
            "&display=page" +
            "&description=" + self.siteDescription +
            "&name=" + self.socialMediaComment() +
            "&link=" + encodeURIComponent(url) + 
            "&redirect_uri=" + encodeURIComponent(url)
    });

    self.linkedinUrl = ko.computed(function() {
        var url = encodeURIComponent(window.location.origin);

        return "http://www.linkedin.com/shareArticle?mini=true" +
            "&url=" + url +
            "&title=" + self.socialMediaComment() +
            "&summary=" + self.siteDescription;
    })

    self.googleplusUrl = ko.computed(function() {
        var url = encodeURIComponent(window.location.origin);

        // So this isn't documented, but when you make an Interactive Post
        // button the user is redirected to a URL such as this.
        return "https://apis.google.com/_/sharebox/dialog?" + 
            "editorText=" + self.socialMediaComment() +
            "&inviteClientId=623511604369-ugqlkfccssq1pgdf9klld1rm53l6epvg.apps.googleusercontent.com" +
            "&callToActionUrl=" + url +
            "&isInteractivePost=true" + 
            "&claimedOrigin=" + url  +
            "&url=" + url +
            "&prm=url&sts=hulnztbt&susp=true&wpp=1&gpsrc=gplp0"
    })

    self.onKeypress = function(data, event) {
        // Force re-evaluation on 'enter'
        if (event.keyCode == 13) self.acronym.valueHasMutated();
        return true;
    }
}

function on_google_load() {
    // Set up the G+ button with default values
    gapi.interactivepost.render('googleplus', {
        contenturl: window.location.origin,
        prefilltext: "TLA! Three Letter Acronyms, just for you.",
        clientid: "623511604369-ugqlkfccssq1pgdf9klld1rm53l6epvg.apps.googleusercontent.com",
        cookiepolicy: 'single_host_origin',
        calltoactionurl: window.location.origin
    });
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

// switches the corresponding social media icon with its onHover countepart
function hover(element) {

    n=element.id;

    switch(n){
        case "twitter_icon":
            element.setAttribute('src', 'styles/images/twitter_hover.png')
            break;
        case "facebook_icon":
            element.setAttribute('src', 'styles/images/facebook_hover.png');
            break;
        case "googleplus_icon":
            element.setAttribute('src', 'styles/images/googleplus_hover.png');
            break;
        case "linkedin_icon":
            element.setAttribute('src', 'styles/images/linkedin_hover.png');
            break;
        default:
            // do nothing
            break;
    }
}

// switches the corresponding social media icon back to the default image
function unhover(element) {

    n=element.id;

    switch(n){
        case "twitter_icon":
            element.setAttribute('src', 'styles/images/twitter.png')
            break;
        case "facebook_icon":
            element.setAttribute('src', 'styles/images/facebook.png');
            break;
        case "googleplus_icon":
            element.setAttribute('src', 'styles/images/googleplus.png');
            break;
        case "linkedin_icon":
            element.setAttribute('src', 'styles/images/linkedin.png');
            break;
        default:
            // do nothing
            break;
    }
}
