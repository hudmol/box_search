
function BoxSearch($search_form, $results_container) {
    this.$search_form = $search_form;
    this.$results_container = $results_container;

    this.setup_form();
}

BoxSearch.prototype.setup_form = function() {
    var self = this;

    $(".box-search-field")[0].focus();

    this.$search_form.on("submit", function(event) {
	    event.preventDefault();
	    self.perform_search(self.$search_form.serializeArray());
	});
};

BoxSearch.prototype.perform_search = function(data) {
    var self = this;

    self.$results_container.closest(".row-fluid").show();
    self.$results_container.html(AS.renderTemplate("template_box_search_results"));

    $.ajax({
	    url:"/plugins/box_search/search",
		data: data,
		type: "post",
		success: function(html) {
		  self.$results_container.html(html);
		  var focus_field = $(".box-search-field")[0];
		  if (focus_field.value == "" && $(".box-search-field")[1].value != "") {
		      focus_field = $(".box-search-field")[1];
		  }
		  focus_field.focus();
		  focus_field.select();
	        },
		error: function(jqXHR, textStatus, errorThrown) {
		  var html = AS.renderTemplate("template_box_search_error_message", {message: jqXHR.responseText})
		    self.$results_container.html(html);
	        }
	});
};

$(function() {

	new BoxSearch(
		      $("#box_search_form"),
		      $("#box_search_results"));
    });
