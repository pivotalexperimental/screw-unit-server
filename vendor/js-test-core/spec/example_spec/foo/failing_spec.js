require("/javascripts/foo");
describe("A failing spec in foo", {
	'fails': function() {
		value_of(Foo.value).should_be(false);
	}
})
