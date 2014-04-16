function AcronymSuggestion(data) {
    this.acronym = ko.observable(data.acronym);
    this.suggestion = ko.observable(data.suggestion);
}

function AcronymSuggestionViewModel() {
    var vm = this;
    vm.acronymSuggestions = ko.observableArray([]);
    $.getJSON("/", function(raw) {
        var acronymSuggestions = $.map(raw, function(item) { return new AcronymSuggestion(item) });
        self.tasks(tasks);
    });
}
ko.applyBindings(new AcronymSuggestionViewModel());