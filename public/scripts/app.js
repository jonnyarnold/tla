function TlaViewModel() {
	var self = this;

	// Establish modeol properties
	self.acronym = ko.observable();
	self.suggestion = ko.observable();

	// Custom subscription to the acronym model property
	// that is invoked any time it changes, via code or 
	// because the user updates it in the DOM. Fetches
	// a suggestion from the server if input is at least
	// 2 characters long.
	self.acronym.subscribe(function(input) {
		if (input.length > 1) {
	 		$.get("/" + self.acronym(), self.suggestion); 
	 	}
	 });

	// Result bound variable will update if suggestion updates.
	// This is then propogated to the DOM via binding.
	self.result = ko.computed(function() { 
		return self.acronym.peek() + ": " + self.suggestion(); 
	})
}

jQuery(document).ready(function() {
    ko.applyBindings(TlaViewModel());
});